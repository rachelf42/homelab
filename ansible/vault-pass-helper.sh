#!/bin/bash
if [[ -r ~/.ansiblepw ]]; then
	cat ~/.ansiblepw
elif (command -v ssh-askpass &>/dev/null); then
	ssh-askpass
else
	echo "$ANSIBLE_VAULT_PASS"
fi
