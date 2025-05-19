pipeline {
  agent any
  stages {
    stage('Get Secrets') {
      steps {
        sh 'rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" -avz rachel@rachel-pc.local.rachelf42.ca:/home/rachel/homelab/secrets/ secrets'
      }
    }
    stage('Packer') {
      steps {
        echo "TODO"
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
