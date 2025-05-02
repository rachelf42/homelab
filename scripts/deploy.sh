#!/bin/bash

HOMELABDIR=${HOMELABDIR:-/home/rachel/homelab} # dev machine may not have env set
function header(){
	if tty -s; then
		cowsay -f hellokitty "$* @ $(date +%T)"
	else
		echo "===== $* @ $(date +%T) ====="
	fi
}

function die(){
	header FINISHED
	exit "$1"
}

POSITIONAL_ARGS=()
PACKER=false
AUTOAPPROVE=false
while [[ $# -gt 0 ]]; do
	case $1 in
		--packer)
			case $2 in
				-*|"")
					PACKER=true
					shift # past argument
					;;
				*)
					PACKER="$2"
					shift # past argument
					shift # past value
					;;
			esac
			;;
		-y|--yes|--assume-yes|-auto-approve|--force)
			AUTOAPPROVE=true
			shift # past argument
			;;
		-*)
			echo "Unknown option $1"
			die 1
			;;
		*)
			POSITIONAL_ARGS+=("$1") # save positional arg
			shift # past argument
			;;
	esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

header "PRE-DEPLOY CHECKS"
if !$AUTOAPPROVE && !(tty -s); then
	echo "FATAL: no attached terminal and auto-approve not set, cannot get approval"
	die 1
fi
(cd "$HOMELABDIR/ansible" && ansible-galaxy install -r requirements.yaml) || die $?
"$HOMELABDIR/scripts/lint.sh" || die $?

case $PACKER in # TODO do a proper CI and run packer daily not just on demand when we anticipate a new install
                # Issue URL: https://github.com/rachelf42/homelab/issues/22
	true|yes|y|1)
		header "STARTED PACKER"
		cd "$HOMELABDIR/packer" || die $?
		packer build -timestamp-ui -force . || die $?
		;;
	*)
		header "SKIPPING PACKER"
		;;
esac

header "STARTED TERRAFORM"
cd "$HOMELABDIR" || die $?
if $AUTOAPPROVE; then
	terraform -chdir=terraform -auto-approve apply || die $?
else
	terraform -chdir=terraform apply || die $?
fi

header "STARTED ANSIBLE"
export ANSIBLE_NOCOWS=1
cd ansible || die $?
header "ANSIBLE PROVISION PLAYBOOK"
ansible-playbook playbooks/provision.yaml || die $?

die 0
