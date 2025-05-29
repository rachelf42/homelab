// TODO: merge with /test.Jenkinsfile
// Issue URL: https://github.com/rachelf42/homelab/issues/53
// assignees: rachelf42
def common
pipeline {
  agent any
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
      }
    }
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
  }
  post {
    failure {
      timestamps {
        script {
          common.sendPushover('❌ DAILY $BUILD_DISPLAY_NAME FAILED! ❌', 1)
        }
      }
    }
  }
}
