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
          sh('wget $JENKINS_URL/jnlpJars/jenkins-cli.jar')
          withCredentials([
            usernamePassword(
              credentialsId: 'meta-login',
              passwordVariable: 'JENKINS_API_TOKEN',
              usernameVariable: 'JENKINS_USER_ID'
            )
          ])
          {
            sh('echo -n "$JENKINS_USER_ID:$JENKINS_API_TOKEN" > meta-creds')
          }
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
            common.sendPushover('test low priority')
            common.sendPushover('test high priority', 1)
          }
          error(message: 'remove pushover test code to continue')
          withCredentials([
            string(credentialsId: 'terratoken', variable: 'TF_TOKEN_app_terraform_io')
          ]) {
            dir('bootstrap') {
              sh('terraform init')
            }
            dir('terraform') {
              sh('terraform init')
            }
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
              // TODO: check maint.yaml doesn't break if jenkins itself updates
              // Issue URL: https://github.com/rachelf42/homelab/issues/55
              // assignees: rachelf42
              sh('~/.local/bin/ansible-playbook playbooks/maint.yaml')
            }
          }
        }
      }
    }
    stage('Meta - Update plugins and restart') {
      steps {
        // TODO: check test.Jenkinsfile updating plugins actually works
        // Issue URL: https://github.com/rachelf42/homelab/issues/54
        // assignees: rachelf42
        sh(
          'java -jar jenkins-cli.jar -auth @meta-creds -s $JENKINS_URL list-plugins ' +
          '| awk \'{ print $1 }\' ' +
          '| xargs java -jar jenkins-cli.jar -auth @meta-creds -s $JENKINS_URL install-plugin'
        )
        sh('java -jar "jenkins-cli.jar" -auth @meta-creds safe-restart')
      }
    }
  }
}