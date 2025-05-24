pipelineJob('main'){
    authenticationToken("${GITHUB_WEBHOOK_TOKEN}")
    properties {
        disableConcurrentBuilds {
            abortPrevious(false)
        }
        pipelineTriggers {
            triggers {
                periodicFolderTrigger {
                    interval('24h')
                }
            }
        }
        githubProjectUrl('https://github.com/rachelf42/homelab')
    }
    definition {
        cpsScm {
            lightweight(false)
            scm {
                github('rachelf42/homelab', 'refs/heads/main')
                scriptPath('jenkins/main.Jenkinsfile')
            }
        }
    }
}