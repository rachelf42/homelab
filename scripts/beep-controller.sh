#!/bin/bash
# vim: set noexpandtab
DOCKERDIR=${DOCKERDIR:-/home/rachel/homelab} # dev machine may not have env set
case "$1" in
	success|0|"")
		"$DOCKERDIR/scripts/beep-yay.sh"
		;;
	*)
		"$DOCKERDIR/scripts/beep-alarm.sh"
		;;
esac
