def unpretty = ~'(^|\n) +'
// TODO: change to pull from NAS
// Issue URL: https://github.com/rachelf42/homelab/issues/40
// labels: waiting, hideFromCodeEditor
def rsync = '''
rsync
  --rsh "ssh
    -o StrictHostKeyChecking=no
    -o UserKnownHostsFile=/dev/null
    -i $HOMELAB_JENKINS_SECRETSYNC_KEY
  " --archive --verbose --compress
  $HOMELAB_JENKINS_SECRETSYNC_USER@rachel-pc.local.rachelf42.ca:/home/rachel/homelab/secrets/ secrets
'''
def pushover_success = '''
curl
  --form-string "token=$APP_TOKEN"
  --form-string "user=$USER_KEY"
  --form-string "message=✅️ Build $BUILD_DISPLAY_NAME Succeeded! ✅️"
  --form-string "device=Rachel-Opera,Rachel-A13"
  --form-string "priority=-1"
  --form-string "url=$BUILD_URL"
  --form-string "url_title=View $BUILD_TAG in Jenkins"
  https://api.pushover.net/1/messages.json
'''
def pushover_fail = '''
curl
  --form-string "token=$APP_TOKEN"
  --form-string "user=$USER_KEY"
  --form-string "message=❌ BUILD $BUILD_DISPLAY_NAME FAILED! ❌"
  --form-string "device=Rachel-Opera,Rachel-A13"
  --form-string "priority=1"
  --form-string "url=$BUILD_URL"
  --form-string "url_title=View $BUILD_TAG in Jenkins"
  https://api.pushover.net/1/messages.json
'''
pipeline {
  agent any
  stages {
    stage('Setup') {
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'homelab-pull-secrets',
          keyFileVariable: 'HOMELAB_JENKINS_SECRETSYNC_KEY',
          passphraseVariable: 'HOMELAB_JENKINS_SECRETSYNC_PASS',
          usernameVariable: 'HOMELAB_JENKINS_SECRETSYNC_USER'
        )]) {
          sh(rsync.replaceAll(unpretty, ' ').trim())
        }
        sh('rm ansible/playbooks/files/id_ed25519 && cp ~/.ssh/id_ed25519 ansible/playbooks/files/id_ed25519')
      }
    }
    // TODO: move packer to its own daily pipeline
    // Issue URL: https://github.com/rachelf42/homelab/issues/39
    // assignees: rachelf42
    // stage('Packer') {
    //   steps {
    //     dir(path: 'packer') {
    //       timestamps {
    //         sh('packer init .')
    //         sh('packer build -force .')
    //       }
    //     }
    //   }
    // }
    stage('Terraform'){
      steps {
        timestamps {
          withCredentials([string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')]) {
            dir('bootstrap') {
              sh('terraform init') // so ansible can access state
            }
            dir('terraform') {
              sh('terraform init')
              def planStatus=sh(
                script: 'terraform plan -input=false -detailed-exitcode -out=jenkins.tfplan',
                returnStatus: true
              )
              switch(planStatus) {
                case 0:
                  echo("no changes, do not apply")
                  break;
                case 1:
                  echo("error, fail build")
                  break;
                case 2:
                  echo("acquire user confirmation, then apply")
                  break;
              }
              sh('terraform apply -input=false jenkins.tfplan')
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
              sh('~/.local/bin/ansible-playbook playbooks/provision.yaml')
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
        withCredentials([
          string(credentialsId: 'pushovertoken', variable: 'APP_TOKEN'),
          string(credentialsId: 'pushoverkey', variable: 'USER_KEY')
        ]) {
          sh(pushover_success.replaceAll(unpretty, ' ').trim())
        }
      }
    }
    failure {
      timestamps {
        withCredentials([
          string(credentialsId: 'pushovertoken', variable: 'APP_TOKEN'),
          string(credentialsId: 'pushoverkey', variable: 'USER_KEY')
        ]) {
          sh(pushover_fail.replaceAll(unpretty, ' ').trim())
        }
      }
    }
  }
}
