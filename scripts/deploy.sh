#!/bin/bash
# vim: set noexpandtab

DOCKERDIR=${DOCKERDIR:-/home/rachel/homelab} # dev machine may not have env set
cd "$DOCKERDIR/iac" || exit 1

terraform -chdir=cloudflare apply || exit 1

cd "$DOCKERDIR/iac/packer" || exit 1
packer build -timestamp-ui -force . || exit 1
cd ".."

terraform -chdir=proxmox apply || exit 1
