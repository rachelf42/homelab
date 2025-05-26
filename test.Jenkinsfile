pipeline {
  agent controller
  stages {
    stage('test') {
      steps {
        script {
          import jenkins.model.*;
          Jenkins.instance.doSafeRestart(null);
        }
      }
    }
  }
}