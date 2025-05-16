1. run the ansible playbook `bootstrap.yaml` against any freshly installed PVE nodes
2. run `./make-and-upload-iso.sh`
3. cd into `/packer` and run `packer build .`
4. cd back into `/bootstrap`, run `terraform apply` to create the jenkins vm
5. run the ansible `provision.yaml` playbook with `--limit jenkins`
6. run the ansible `bootstrap.yaml` playbook with `--limit jenkins`