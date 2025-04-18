#!/bin/bash
DOCKERDIR=${DOCKERDIR:-/home/rachel/homelab} # dev machine may not have env set
case "$1" in
	long)
		"$DOCKERDIR/scripts/beep-long.sh"
		;;
	success|0|"")
		"$DOCKERDIR/scripts/beep-yay.sh"
		;;
	*)
		"$DOCKERDIR/scripts/beep-alarm.sh"
		;;
esac
