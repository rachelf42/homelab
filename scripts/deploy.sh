#!/bin/bash
# TODO --assume-yes argument

HOMELABDIR=${HOMELABDIR:-/home/rachel/homelab} # dev machine may not have env set
function header(){
	cowsay -f hellokitty "$* @ $(date +%T)" # TODO test tty and do a single line instead
}

function die(){
	header FINISHED
	exit "$1"
}

POSITIONAL_ARGS=()
PACKER=false
while [[ $# -gt 0 ]]; do
	case $1 in
		--packer) # only one arg for now but doing it this way is both future-proof and makes subsequent arguments override previous ones
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

header "PRE-DEPLOY LINT CHECK"
(cd "$HOMELABDIR/ansible" && ansible-galaxy install -r requirements.yaml) || die $?
"$HOMELABDIR/scripts/lint.sh" || die $?

case $PACKER in # TODO do a proper CI and run packer daily not just on demand when we anticipate a new install
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
terraform -chdir=terraform apply || die $?

header "STARTED ANSIBLE"
export ANSIBLE_NOCOWS=1
cd ansible || die $?
header "ANSIBLE PROVISION PLAYBOOK"
ansible-playbook playbooks/provision.yaml || die $?

die 0
