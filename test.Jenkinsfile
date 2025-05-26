pipeline {
  agent controller
  stages {
    stage('test') {
      steps {
        script {
          import hudson.model.*
          Jenkins.instance.doSafeRestart(null);
        }
      }
    }
  }
}