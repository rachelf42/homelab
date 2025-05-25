1. cd into [/ansible](../ansible), run the ansible playbook [bootstrap.yaml](../ansible/playbooks/bootstrap.yaml) against any freshly installed PVE nodes
2. run [make-and-upload-iso.sh](./make-and-upload-iso.sh)
3. cd into [/packer](../packer) and run `packer build .`
4. cd back into this dir (/bootstrap), run `terraform apply` to create the jenkins vm
5. cd into [/ansible](../ansible), run the ansible provision.yaml playbook [provision.yaml](../ansible/playbooks/provision.yaml)
6. run the [bootstrap.yaml](../ansible/playbooks/bootstrap.yaml) playbook with `--limit jenk`
7. run the [deploy.yaml](../ansible/playbooks/deploy.yaml) playbook. it will fail at the `pull secrets` task.
8. when it does, `ssh jenkins@jenkins`, edit [pullSecrets.sh](../scripts/pullSecrets.sh) to refer to the devmachine by IP address, run deploy.yaml again with `--start-at-task 'pull images'`
9. cd into [/terraform](../terraform/), run `terraform apply`
10. copy the output github-jenkins-webhookurl, paste it into the [github repository secret](https://github.com/rachelf42/homelab/settings/secrets/actions) JENKINS_HOOK_URL
11. trigger the webhook for testing, either by making a trivial commit or by rerunning a previous [github actions deploy job](../.github/workflows/main.yaml)