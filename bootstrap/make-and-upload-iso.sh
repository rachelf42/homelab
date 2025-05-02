#!/bin/bash
# creates an iso with an autoinstall yaml baked in
# and uploads it to proxmox
# TODO: deprecate and setup a PXE server
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
	case $1 in
		# can be any valid ip/dns to a pve node in the cluster
		--proxmox-host)
			PVE="$2"
			shift # past argument
			shift # past value
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

if [[ $PVE == "" ]]; then read -t 10 -p "Target Node IP Address: " PVE || die $?; fi

function header(){
	cowsay -f hellokitty "$* @ $(date +%T)" # TODO test tty and do a single line instead
}
function die(){
	header FINISHED
	exit "$1"
}

HOMELABDIR=${HOMELABDIR:-/home/rachel/homelab} # dev machine may not have env set
cd "$HOMELABDIR/bootstrap" || exit 1

header "STARTING BOOTSTRAP"
if [[ ! -f ./ubuntu-noble-original.iso ]]; then
	if [[ -e ./ubuntu-24.04.2-live-server-amd64.iso ]]; then rm -rf ./ubuntu-24.04.2-live-server-amd64.iso; fi
	header "DOWNLOADING ISO FILE"
	wget --tries 5 --retry-on-host-error \
		--no-clobber --continue --show-progress \
		https://releases.ubuntu.com/24.04.2/ubuntu-24.04.2-live-server-amd64.iso || die $?
	wget https://releases.ubuntu.com/24.04.2/SHA256SUMS || die $?
	sha256sum --check --ignore-missing SHA256SUMS || die $?
	mv ubuntu-24.04.2-live-server-amd64.iso ubuntu-noble-original.iso || die $?
	rm SHA256SUMS || die $?
	MSG="HASH OK"
else
	MSG="ISO EXISTS"
fi
header "$MSG - CALLING AUTOINSTALL GENERATOR"
./ubuntu-autoinstall-generator.sh --all-in-one --no-verify \
	--user-data ubuntu-autoinstall.yaml \
	--source ./ubuntu-noble-original.iso \
	--destination ./ubuntu-noble-autoinstall.iso || die $?
header "COPYING ISO FILE" # TODO copy to NAS instead
scp -o StrictHostKeyChecking=accept-new -i ./ansible_ssh_key \
	./ubuntu-noble-autoinstall.iso "$PVE:~/ubuntu-noble-autoinstall.iso" || die $?
ssh "$PVE" "sudo chown root:root ~/ubuntu-noble-autoinstall.iso" || die $?
ssh "$PVE" "sudo mv ~/ubuntu-noble-autoinstall.iso /var/lib/vz/template/iso/" || die $?
header "STARTING PACKER"
cd "$HOMELABDIR/packer" || die $?
packer build --force . || die $?
header "BOOTSTRAP COMPLETED SUCCESSFULLY"