def unpretty = ~'(^|\n) +'
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
          sh rsync.replaceAll(unpretty, ' ').trim()
        }
      }
    }
    stage('Packer') { // TODO: move packer to its own daily pipeline
      environment {   // Issue URL: https://github.com/rachelf42/homelab/issues/22
        PACKER_NO_COLOR = true
      }
      steps {
        dir(path: 'packer') {
          timestamps {
            sh 'packer init .'
            sh 'packer build -force .'
          }
        }
      }
    }
    stage('Terraform'){
      steps {
        echo "TODO"
      }
    }
    stage('Ansible'){
      steps {
        echo "TODO"
      }
    }
  }
}
