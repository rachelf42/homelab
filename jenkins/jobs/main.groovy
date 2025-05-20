pipelineJob('main'){
    throttleConcurrentBuilds {
        maxPerNode(1)
        maxTotal(1)
    }
    properties {
        pipelineTriggers {
            triggers {
                // TODO: setup github push hook for jenkins
                // labels: enhancement
                githubPush()
                periodicFolderTrigger {
                    interval('24h')
                }
            }
        }
        githubProjectUrl('https://github.com/rachelf42/homelab')
        ownership {
            primaryOwnerId('rachel')
        }
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