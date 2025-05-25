// TODO: deduplicate sendPushover in Jenkinsfiles
// labels: enhancement
def sendPushover(message, priority = 0) {
  withCredentials([
    string(credentialsId: 'pushovertoken', variable: 'APP_TOKEN'),
    string(credentialsId: 'pushoverkey', variable: 'USER_KEY')
  ]) {
    sh('$WORKSPACE/scripts/sendPushover.sh ' + priority + ' ' + message)
  }
}
pipeline {
  agent any
  options {
    skipDefaultCheckout(true)
    buildBlocker (
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
        sendPushover('❌ BUILD $BUILD_DISPLAY_NAME FAILED! ❌', 1)
      }
    }
  }
}
