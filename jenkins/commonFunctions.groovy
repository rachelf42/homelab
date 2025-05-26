def sendPushover(message, priority = 0) {
  withCredentials([
    string(credentialsId: 'pushovertoken', variable: 'APP_TOKEN'),
    string(credentialsId: 'pushoverkey', variable: 'USER_KEY')
  ]) {
    // $WORKSPACE used because we don't know what directory we'll be in when we call this
    sh('$WORKSPACE/scripts/sendPushover.sh ' + priority + ' ' + message)
  }
}

return this