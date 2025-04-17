#!/bin/bash
# vim: set noet
# remember that an ANSIBLE_VAULT_PASSWORD_FILE env var will override ansible.cfg
if (command -v ssh-askpass &>/dev/null); then
	ssh-askpass
else
	echo "$ANSIBLE_VAULT_PASS"
fi
