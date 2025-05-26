pipeline {
  agent {label 'controller'}
  stages {
    stage('test') {
      steps {
        sh('wget http://$JENKINS_URL/jnlpJars/jenkins-cli.jar')
        sh('java -jar "jenkins-cli.jar" -s "$JENKINS_URL" safe-restart')
      }
    }
  }
}