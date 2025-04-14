#!/bin/bash
# vim: set noexpandtab

DOCKERDIR=${DOCKERDIR:-/home/rachel/homelab} # dev machine may not have env set
cd "$DOCKERDIR/iac" || exit 1

terraform -chdir=cloudflare apply || exit 1

cd packer || exit 1
packer build -timestamp-ui -force . || exit 1
cd ..

terraform -chdir=proxmox apply || exit 1

cd ansible || exit 1
ansible-playbook --limit '!nas' playbook/provision.yaml || exit 1
