#!/bin/bash

HOMELABDIR=${HOMELABDIR:-/home/rachel/homelab} # dev machine may not have env set
EC=0
cd "$HOMELABDIR" || exit 1

if ! (shellcheck -a ./scripts/*.sh ./.git/hooks/pre-push &>/dev/null); then
	EC=$((EC + 1))
	echo '===== SHELLCHECK FAILED ====='
	shellcheck -a ./scripts/*.sh ./.git/hooks/pre-push
fi

if ! (yamllint --strict . &>/dev/null); then
	EC=$((EC + 1))
	echo '===== YAMLLINT FAILED ====='
	yamllint .
fi

if ! (npx dclint ./docker/*.compose.yaml --max-warnings 0 &>/dev/null); then
	EC=$((EC + 1))
	echo '===== DCLINT FAILED ====='
	npx dclint ./docker/*.compose.yaml
fi

cd "$HOMELABDIR/packer" || exit 1
if (packer validate . &>/dev/null); then
	packer fmt . &>/dev/null
else
	EC=$((EC + 1))
	echo '===== PACKER FAILED ====='
	packer validate .
fi

cd "$HOMELABDIR/terraform" || exit 1
if (terraform validate &>/dev/null); then
	terraform fmt ./* &>/dev/null
else
	EC=$((EC + 1))
	echo '===== TERRAFORM FAILED ====='
	terraform validate
fi

cd "$HOMELABDIR/ansible" || exit 1
if ! (ansible-lint &>/dev/null); then
	EC=$((EC + 1))
	echo '===== ANSIBLE FAILED ====='
	ansible-lint
fi

if [[ $EC == 0 ]]; then cowsay -f hellokitty 'All Lint Checks Succeeded!'; fi
exit $EC
