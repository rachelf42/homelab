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
def preansible = '''
#!/bin/sh
export PATH=$PATH:$HOME/.local/bin # where pipx installs stuff
rm playbooks/files/id_ed25519
cp ~/.ssh/id_ed25519 playbooks/files/id_ed25519
ansible-galaxy collection install -r requirements.yaml
'''
def pushover_success = '''
curl
  --form-string "token=$APP_TOKEN"
  --form-string "user=$USER_KEY"
  --form-string "message=✅️ Build $BUILD_DISPLAY_NAME Succeeded! ✅️"
  --form-string "devices=Rachel-Opera,Rachel-A13"
  --form-string "priority=-1"
  --form-string "url=$BUILD_URL"
  --form-string "url_title=$BUILD_TAG"
  https://api.pushover.net/1/messages.json
'''
def pushover_fail = '''
curl
  --form-string "token=$APP_TOKEN"
  --form-string "user=$USER_KEY"
  --form-string "message=❌ BUILD $BUILD_DISPLAY_NAME FAILED! ❌"
  --form-string "devices=Rachel-Opera,Rachel-A13"
  --form-string "priority=1"
  --form-string "url=$BUILD_URL"
  --form-string "url_title=$BUILD_TAG"
  https://api.pushover.net/1/messages.json
'''
pipeline {
  agent any
  stages {
    stage('Get Secrets') {
      steps {
        withCredentials([sshUserPrivateKey(
          credentialsId: 'homelab-pull-secrets',
          keyFileVariable: 'HOMELAB_JENKINS_SECRETSYNC_KEY',
          passphraseVariable: 'HOMELAB_JENKINS_SECRETSYNC_PASS',
          usernameVariable: 'HOMELAB_JENKINS_SECRETSYNC_USER'
        )]) {
          sh(rsync.replaceAll(unpretty, ' ').trim())
        }
      }
    }
    // TODO: move packer to its own daily pipeline
    // Issue URL: https://github.com/rachelf42/homelab/issues/39
    stage('Packer') {
      steps {
        dir(path: 'packer') {
          timestamps {
            sh('packer init .')
            sh('packer build -force .')
          }
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
              sh('terraform plan -out=jenkins.tfplan')
              input(
                message: 'Approve Terraform Plan?',
                ok: 'Approve',
                cancel: 'Cancel',
                submitter: 'rachel'
              )
              sh('terraform apply jenkins.tfplan')
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
              sh(preansible.trim())
              sh('ansible-playbook playbooks/provision.yaml')
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
              sh(preansible.trim())
              sh('ansible-playbook playbooks/deploy.yaml')
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
