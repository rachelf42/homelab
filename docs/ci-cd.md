---
icon: jenkins
---

# CI/CD

Github Actions is used for anything thats more related to the code itself, eg. linting, issue management

Jenkins handles all the actual deployment once GHA "signs off" by running the deploy action in [main.yaml](https://github.com/rachelf42/homelab/tree/main/.github/workflows/main.yaml) (which itself just calls [triggerJenkinsBuild.sh](https://github.com/rachelf42/homelab/tree/main/scripts/triggerJenkinsBuild.sh))

Jenkins is installed on-prem using a special [bootstrapping](bootstrapping.md) terraform workspace, and then will maintain itself.
