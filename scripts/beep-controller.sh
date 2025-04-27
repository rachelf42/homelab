#!/bin/bash
HOMELABDIR=${HOMELABDIR:-/home/rachel/homelab} # dev machine may not have env set
case "$1" in
	long)
		"$HOMELABDIR/scripts/beep-long.sh"
		;;
	success|0|"")
		"$HOMELABDIR/scripts/beep-yay.sh"
		;;
	*)
		"$HOMELABDIR/scripts/beep-alarm.sh"
		;;
esac
