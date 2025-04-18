#!/bin/bash
# TODO --assume-yes argument

DOCKERDIR=${DOCKERDIR:-/home/rachel/homelab} # dev machine may not have env set
function header(){
	cowsay -f hellokitty "$* @ $(date +%T)" # TODO test tty and do a single line instead
}

function die(){
	header FINISHED
	exit "$1"
}

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
	case $1 in
		-f|--fast|--no-packer) # only one arg for now but doing it this way is both future-proof and makes subsequent arguments override previous ones
			case $2 in
				-*|"")
					NOPACKER=true
					shift # past argument
					;;
				*)
					NOPACKER="$2"
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
"$DOCKERDIR/scripts/lint.sh" || die 1

header "STARTED TERRAFORM/NETWORK"
cd "$DOCKERDIR/iac" || die 1
terraform -chdir=terraform/network apply || die 1
case $NOPACKER in
	true|yes|y|1)
		echo "Fast Mode: assuming packer is already setup, will crash if not"
		;;
	*)
		header "STARTED PACKER"
		cd packer || die 1
		packer build -timestamp-ui -force . || die 1
		cd "$DOCKERDIR/iac" || die 1
		;;
esac
header "STARTED TERRAFORM/SERVERS"
terraform -chdir=terraform/servers apply || die 1

header "STARTED ANSIBLE"
export ANSIBLE_NOCOWS=1
cd ansible || die 1
ansible-galaxy install -r requirements.yaml || die 1
header "ANSIBLE PROVISION PLAYBOOK"
ansible-playbook --limit '!nas' playbooks/provision.yaml || die 1
header "ANSIBLE SYNC PLAYBOOK"
ansible-playbook --limit 'mediasrv:devmachine' playbooks/sync.yaml || die 1

die 0
