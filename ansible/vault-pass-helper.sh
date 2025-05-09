#!/bin/bash
# remember that an ANSIBLE_VAULT_PASSWORD_FILE env var will override ansible.cfg
if [[ -r ~/.ansiblepw ]]; then
	cat ~/.ansiblepw
elif (command -v ssh-askpass &>/dev/null); then
	ssh-askpass
else
	echo "$ANSIBLE_VAULT_PASS"
fi
