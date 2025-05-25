pipelineJob('daily'){
    quietPeriod(120)
    properties {
        disableConcurrentBuilds {
            abortPrevious(false)
        }
        pipelineTriggers {
            triggers {
              // trigger go here
            }
        }
        githubProjectUrl('https://github.com/rachelf42/homelab')
    }
    definition {
        cpsScm {
            lightweight(false)
            scm {
                github('rachelf42/homelab', 'refs/heads/main')
                scriptPath('jenkins/daily.Jenkinsfile')
            }
        }
    }
}