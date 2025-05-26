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
        sh('wget http://$JENKINS_URL/jnlpJars/jenkins-cli.jar')
        sh('java -jar "jenkins-cli.jar" safe-restart')
      }
    }
  }
}