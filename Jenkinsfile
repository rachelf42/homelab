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
    stage('Packer') {
      steps {
        dir(path: 'packer') {
          sh 'packer init .'
          sh 'packer build -timestamp-ui -force .'
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
