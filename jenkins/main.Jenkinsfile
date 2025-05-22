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
def ansible = '''
#!/bin/sh
export PATH=$PATH:$HOME/.local/bin # where pipx installs stuff
ansible-galaxy collection install -r requirements.yaml
rm playbooks/files/id_ed25519
cp ~/.ssh/id_ed25519 playbooks/files/id_ed25519
ansible-playbook playbooks/provision.yaml
'''
def pushover_success = '''
curl
  --form-string "token=$APP_TOKEN"
  --form-string "user=$USER_KEY"
  --form-string "message=hello world"
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
    stage('Ansible'){
      steps {
        dir(path: 'ansible') {
          withCredentials([
            string(credentialsId: 'ansivault', variable: 'ANSIBLE_VAULT_PASS'),
            string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
          ]) {
            sh(ansible.trim())
          }
        }
      }
    }
  }
  post {
    always {
      sh(pushover_success.replaceAll(unpretty, ' ').trim())
    }
  }
}
