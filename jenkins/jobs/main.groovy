pipelineJob('main'){
    authenticationToken("${GITHUB_WEBHOOK_TOKEN}")
    properties {
        disableConcurrentBuilds {
            abortPrevious(false)
        }
        pipelineTriggers {
            triggers {
                // TODO: setup github push hook for jenkins
                // Issue URL: https://github.com/rachelf42/homelab/issues/42
                // labels: enhancement
                githubPush()
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