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
      environment {
        PACKER_NO_COLOR = true
      }
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
      environment {
        TF_IN_AUTOMATION = "jenkins"
      }
      steps {
        dir(path: 'terraform'){
          timestamps {
            sh('terraform init')
            sh('terraform plan -out=jenkins.tfplan')
            input(
              message: 'Approve Terraform Plan?',
              ok: 'Approve',
              cancel: 'Cancel',
              submitter: 'rachel'
            )
            sh('terraform apply -auto-approve jenkins.tfplan')
          }
        }
      }
    }
    stage('Ansible'){
      environment {
        ANSIBLE_NOCOWS=1
      }
      steps {
        dir(path: 'ansible') {
          sh('ansible-galaxy install -r requirements.yaml')
          sh('ansible --version')
        }
      }
    }
  }
}
