def common
pipeline {
  options {
    skipDefaultCheckout(true)
    buildBlocker(
      useBuildBlocker: true,
      blockLevel: 'GLOBAL',
      scanQueueFor: 'ALL',
      blockingJobs: '.*'
    )
  }
  agent {label 'controller'}
  stages {
    stage('Setup') {
      steps {
        timestamps() {
          cleanWs()
          checkout scm
          sh('rm ansible/playbooks/files/id_ed25519 && cp ~/.ssh/id_ed25519 ansible/playbooks/files/id_ed25519')
          script {
            common = load('jenkins/commonFunctions.groovy')
          }
          dir('bootstrap') {
            sh('terraform init')
          }
          dir('terraform') {
            sh('terraform init')
          }
        }
      }
    }
    stage('Ansible - Maintenance') {
      steps {
        dir(path: 'ansible') {
          timestamps {
            withCredentials([
              string(credentialsId: 'ansivault', variable: 'ANSIBLE_VAULT_PASS'),
              string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
            ]) {
              sh('~/.local/bin/ansible-galaxy collection install -r requirements.yaml')
              sh('~/.local/bin/ansible-playbook playbooks/maint.yaml')
            }
          }
        }
      }
    }
    stage('Restart') {
      steps {
        sh('wget $JENKINS_URL/jnlpJars/jenkins-cli.jar')
        withCredentials([
          usernamePassword(
            credentialsId: 'meta-login',
            passwordVariable: 'JENKINS_API_TOKEN',
            usernameVariable: 'JENKINS_USER_ID'
          )
        ])
        {
          sh('echo -n "$JENKINS_USER_ID:$JENKINS_API_TOKEN" > creds')
        }
        // sh('java -jar "jenkins-cli.jar" -auth @creds safe-restart')
      }
    }
  }
}