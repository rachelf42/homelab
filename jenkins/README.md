Github Actions is used instead of Jenkins for anything thats more related to the code itself
eg. linting, repository management

Jenkins handles all the actual deployment once GHA "signs off" by running the deploy action in [main.yaml](../.github/workflows/main.yaml)
(which itself just calls [triggerJenkinsBuild.sh](../scripts/triggerJenkinsBuild.sh))
