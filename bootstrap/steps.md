1. run the ansible playbook `bootstrap.yaml` against any freshly installed PVE nodes
2. run `./make-and-upload-iso.sh`
3. run `terraform apply` in this directory to create the cicd stuff
4. do the rest of the deploy normally