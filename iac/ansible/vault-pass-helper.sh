#!/bin/bash
# vim: set noet
if [[ -r ~/.ansiblepw ]]; then
	cat ~/.ansiblepw
elif dpkg -l ssh-askpass &>/dev/null; then
	ssh-askpass
else
	echo "$ANSIBLE_VAULT_PASS"
fi
