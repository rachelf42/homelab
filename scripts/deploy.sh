#!/bin/bash
echo "DEPRECATED: USING JENKINS NOW"
tput bel
exit 1

header "PRE-DEPLOY CHECKS"
if ! $AUTOAPPROVE && ! (tty -s); then
	echo "FATAL: no attached terminal and auto-approve not set, cannot get approval"
	die 1
fi
(cd "$HOMELABDIR/ansible" && ansible-galaxy install -r requirements.yaml) || die $?
(cd "$HOMELABDIR/terraform" && terraform init) || die $?

header "STARTED TERRAFORM"
cd "$HOMELABDIR" || die $?
if $AUTOAPPROVE; then
	terraform -chdir=terraform apply -auto-approve || die $?
else
	terraform -chdir=terraform apply || die $?
fi

header "STARTED ANSIBLE"
export ANSIBLE_NOCOWS=1
cd ansible || die $?
header "ANSIBLE PROVISION PLAYBOOK"
ansible-playbook playbooks/provision.yaml || die $?