---
icon: boot
---

# Bootstrapping

As you follow these instructions, things will inevitably fail due to the secrets dir being empty, unless [pre-populated](secrets.md)

#### Steps:

1. ensure all required tools below are installed, and an empty [Proxmox](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso) node is ready-to-go:
   * [Hashicorp Terraform](https://developer.hashicorp.com/terraform/install#linux)
   * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx) (or ansible-core)
   * [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md#official-sources)
2. cd into /ansible, run the ansible playbook bootstrap.yaml against any freshly installed PVE nodes
3. run make-and-upload-iso.sh
4. cd into /packer and run `packer build .`
5. cd back into this dir (/bootstrap), run `terraform apply` to create the jenkins vm
6. cd into /ansible, run the ansible provision.yaml playbook provision.yaml
7. run the bootstrap.yaml playbook with `--limit jenk`
8. run the deploy.yaml playbook. it will fail at the `pull secrets` task.
9. when it does, `ssh jenkins@jenkins`, edit pullSecrets.sh to refer to the devmachine by IP address, run deploy.yaml again with `--start-at-task 'pull images'`
10. undo the previous change to pullSecrets.sh
11. cd into /terraform, run `terraform apply`
12. copy the output github-jenkins-webhookurl, paste it into `gh secret set JENKINS_HOOK_URL`
13. cd into /secrets, run `tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 32 >github_webhook_token`
14. run `cat github_webhook_token | gh secret set JENKINS_HOOK_TOKEN`
15. ssh into the control vm and run `docker compose up -d lldap`
16. cd into /bootstrap/postdeploy, run `terraform apply` to configure LLDAP
