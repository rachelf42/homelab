pipeline {
  agent controller
  stages {
    stage('test') {
      steps {
        sh('java -jar "$JENKINS_HOME/war/WEB-INF/jenkins-cli.jar" -s "$JENKINS_URL" safe-restart')
      }
    }
  }
}