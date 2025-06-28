def common
pipeline {
  agent{ label 'controller' }
  options {
    skipDefaultCheckout(true)
    buildBlocker(
      useBuildBlocker: true,
      blockLevel: 'GLOBAL',
      scanQueueFor: 'ALL',
      blockingJobs: '.*' // block on everything
    )
  }
  stages {
    stage('Setup') {
      agent any
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
        script {
          common = load('jenkins/commonFunctions.groovy')
        }
        sh('wget $JENKINS_URL/jnlpJars/jenkins-cli.jar')
        withCredentials([
          usernamePassword(
            credentialsId: 'meta-login',
            passwordVariable: 'JENKINS_API_TOKEN',
            usernameVariable: 'JENKINS_USER_ID'
          )
        ]){
          sh('echo -n "$JENKINS_USER_ID:$JENKINS_API_TOKEN" > meta-creds')
        }
        withCredentials([
          string(credentialsId: 'ansivault', variable: 'ANSIBLE_VAULT_PASS'),
          string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
        ]) {
          sh('~/.local/bin/ansible-galaxy collection install -r requirements.yaml')
        }
        sh('rm ansible/playbooks/files/id_ed25519 && cp ~/.ssh/id_ed25519 ansible/playbooks/files/id_ed25519')
        withCredentials([
          string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
        ]){
          dir('bootstrap') {
            sh('terraform init')
          }
          dir('terraform') {
            sh('terraform init')
          }
        }
        stash('setup')
      }
    }
    stage('Packer') {
      agent any
      steps {
        cleanWs()
        unstash('setup')
        dir(path: 'packer') {
          timestamps {
            sh('packer init .')
            sh('packer build -force .')
          }
        }
      }
    }
    stage('Ansible - Maintenance') {
      agent { label 'controller' }
      steps {
        cleanWs()
        unstash('setup')
        dir(path: 'ansible') {
          timestamps {
            withCredentials([
              string(credentialsId: 'ansivault', variable: 'ANSIBLE_VAULT_PASS'),
              string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
            ]) {
              sh('~/.local/bin/ansible-galaxy collection install -r requirements.yaml')
              retry(5) {
                sh('~/.local/bin/ansible-playbook playbooks/maint.yaml')
              }
            }
          }
        }
      }
    }
    stage('Meta - Update plugins and restart') {
      agent{ label 'controller' }
      steps {
        cleanWs()
        unstash('setup')
        sh(
          'java -jar jenkins-cli.jar -auth @meta-creds -s $JENKINS_URL list-plugins ' +
          '| awk \'{ print $1 }\' ' +
          '| xargs java -jar jenkins-cli.jar -auth @meta-creds -s $JENKINS_URL install-plugin'
        )
        sh('java -jar "jenkins-cli.jar" -auth @meta-creds safe-restart')
      }
    }
  }
  post {
    failure {
      timestamps {
        unstash('setup')
        script {
          common.sendPushover('❌ DAILY $BUILD_DISPLAY_NAME FAILED! ❌', 1)
        }
      }
    }
  }
}
