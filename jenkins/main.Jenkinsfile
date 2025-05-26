def common
pipeline {
  agent any
  options {
    skipDefaultCheckout(true)
    buildBlocker (
      useBuildBlocker: true,
      blockLevel: 'GLOBAL',
      scanQueueFor: 'DISABLED',
      blockingJobs: 'daily' // because it runs packer
    )
  }
  stages {
    stage('Setup') {
      steps {
        cleanWs()
        checkout scm
        withCredentials([sshUserPrivateKey(
          credentialsId: 'homelab-pull-secrets',
          keyFileVariable: 'SYNC_KEY',
          usernameVariable: 'SYNC_USER'
        )]) {
          sh('./scripts/pullSecrets.sh')
        }
        sh('rm ansible/playbooks/files/id_ed25519 && cp ~/.ssh/id_ed25519 ansible/playbooks/files/id_ed25519')
        script {
          common = load('jenkins/commonFunctions.groovy')
        }
      }
    }
    stage('Terraform'){
      steps {
        timestamps {
          withCredentials([string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')]) {
            dir('bootstrap') {
              sh('terraform init') // so ansible can access state
            }
            dir('terraform') {
              sh('terraform init')
              script {
                def planStatus=sh(
                  script: 'terraform plan -input=false -detailed-exitcode -out=jenkins.tfplan',
                  returnStatus: true
                )
                switch(planStatus) {
                  case 0:
                    // no changes, do nothing
                    break;
                  case 1:
                    error 'Terraform Failed'
                    break;
                  case 2:
                    common.sendPushover('⚠️ Build $BUILD_DISPLAY_NAME Awaits Input ⚠️')
                    input(
                      message: 'Proceed with above plan?',
                      submitter: 'rachel'
                    )
                    sh('terraform apply -input=false jenkins.tfplan')
                    break;
                }
              }
            }
          }
        }
      }
    }
    stage('Ansible - PostProvisioning'){
      steps {
        dir(path: 'ansible') {
          timestamps {
            withCredentials([
              string(credentialsId: 'ansivault', variable: 'ANSIBLE_VAULT_PASS'),
              string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
            ]) {
              sh('~/.local/bin/ansible-galaxy collection install -r requirements.yaml')
              retry(5) {
                sh('~/.local/bin/ansible-playbook playbooks/provision.yaml')
              }
            }
          }
        }
      }
    }
    stage('Ansible - Deploy'){
      steps {
        dir(path: 'ansible') {
          timestamps {
            withCredentials([
              string(credentialsId: 'ansivault', variable: 'ANSIBLE_VAULT_PASS'),
              string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
            ]) {
              sh('~/.local/bin/ansible-galaxy collection install -r requirements.yaml')
              sh('~/.local/bin/ansible-playbook playbooks/deploy.yaml')
            }
          }
        }
      }
    }
  }
  post {
    success {
      timestamps {
        script {
          common.sendPushover('✅️ Build $BUILD_DISPLAY_NAME Succeeded! ✅️', -1)
        }
      }
    }
    failure {
      timestamps {
        script {
          common.sendPushover('❌ BUILD $BUILD_DISPLAY_NAME FAILED! ❌', 1)
        }
      }
    }
  }
}
