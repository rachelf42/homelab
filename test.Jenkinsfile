pipeline {
  options {
    skipDefaultCheckout(true)
    buildBlocker (
      useBuildBlocker: true,
      blockLevel: 'GLOBAL',
      scanQueueFor: 'ALL',
      blockingJobs: '.*'
    )
  }
  agent {label 'controller'}
  stages {
    stage('test') {
      steps {
        cleanWs()
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
        sh('java -jar "jenkins-cli.jar" -auth @creds safe-restart')
      }
    }
  }
}