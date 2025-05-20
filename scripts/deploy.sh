#!/bin/bash
# shellcheck disable=SC2317
echo "DEPRECATED: USING JENKINS NOW"
tput bel
exit 1

ansible-playbook playbooks/provision.yaml || die $?