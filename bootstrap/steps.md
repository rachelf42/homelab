As you follow these instructions, things will inevitably fail due to the secrets dir being empty, unless pre-populated (see that dir's [README](/secrets/README.md)).

### Steps:
0. ensure all required tools below are installed, and an empty [Proxmox](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso) node is ready-to-go:
    * [Hashicorp Terraform](https://developer.hashicorp.com/terraform/install#linux)
    * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx) (or ansible-core)
    * [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md#official-sources)
1. cd into [/ansible](/ansible), run the ansible playbook [bootstrap.yaml](/ansible/playbooks/bootstrap.yaml) against any freshly installed PVE nodes
2. run [make-and-upload-iso.sh](./make-and-upload-iso.sh)
3. cd into [/packer](/packer) and run `packer build .`
4. cd back into this dir (/bootstrap), run `terraform apply` to create the jenkins vm
5. cd into [/ansible](/ansible), run the ansible provision.yaml playbook [provision.yaml](/ansible/playbooks/provision.yaml)
6. run the [bootstrap.yaml](/ansible/playbooks/bootstrap.yaml) playbook with `--limit jenk`
7. run the [deploy.yaml](/ansible/playbooks/deploy.yaml) playbook. it will fail at the `pull secrets` task.
8. when it does, `ssh jenkins@jenkins`, edit [pullSecrets.sh](/scripts/pullSecrets.sh) to refer to the devmachine by IP address, run deploy.yaml again with `--start-at-task 'pull images'`
9. undo the previous change to [pullSecrets.sh](/scripts/pullSecrets.sh)
10. cd into [/terraform](/terraform/), run `terraform apply`
11. copy the output github-jenkins-webhookurl, paste it into `gh secret set JENKINS_HOOK_URL`
12. cd into [/secrets](/secrets), run `tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 32 >github_webhook_token`
13. run `cat github_webhook_token | gh secret set JENKINS_HOOK_TOKEN`
14. ssh into the control vm and run `docker compose up -d lldap`
15. cd into [/bootstrap/postdeploy](/bootstrap/postdeploy), run `terraform apply` to configure LLDAP