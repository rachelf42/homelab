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
        sh('wget $JENKINS_URL/jnlpJars/jenkins-cli.jar')
        withCredentials([
          usernamePassword(
            credentialsId: 'meta-login',
            passwordVariable: 'JENKINS_API_TOKEN',
            usernameVariable: 'JENKINS_USER_ID'
          )
        ])
        {
          sh('java -jar "jenkins-cli.jar" login')
        }
        sh('java -jar "jenkins-cli.jar" safe-restart')
      }
    }
  }
}