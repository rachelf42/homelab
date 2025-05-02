#!/bin/bash
# this script will send a notification to notifiarr if theres any apt upgrades available
# intended to be run via crontab every week or so, but can also be run manually with --single
# that'll just just do a dry-run upgrade on the local machine and spit out the upgradeable packages
# running with no args will use parallel-ssh to run on all hosts

set -o allexport # needed for envsubst below

HOMELABDIR='/home/rachel/homelab'
# gets matching line and the indented block afterwards
APT_COMMAND="sudo apt-get --dry-run upgrade | sed -n '/The following packages will be upgraded/{:1;p;n;/^\s\{1,18\}\S/b1}'"

if [[ $1 = "--single" ]]; then
	sudo apt-get update
	exec "$APT_COMMAND"
	exit 0
fi

PING_CHANNEL=$(cat "$HOMELABDIR/secrets/discord-channel-id" 2>/dev/null)
if [[ -z "$PING_CHANNEL" ]]; then echo "Discord Channel Required" 1>&2; exit 1; fi

APIKEY=$(cat "$HOMELABDIR/secrets/notifiarr-passthru-key" 2>/dev/null)
if [[ -z "$APIKEY" ]]; then echo "Notifiarr API Key Required" 1>&2; exit 1; fi

PING_USER=$(cat "$HOMELABDIR/secrets/discord-user-id" 2>/dev/null)
if [[ -z "$PING_USER" ]]; then PING_USER=0; fi

parallel-ssh \
	--timeout 0 \
	--hosts $HOMELABDIR/pssh/all.hosts \
	-O StrictHostKeyChecking=no \
	-O UserKnownHostsFile=/dev/null \
	-O GlobalKnownHostsFile=/dev/null \
	'sudo apt-get update' >/dev/null || exit 1

TMPDIR=$(mktemp -d)
TMPFILE=$(mktemp)

# idk maybe mktemp isnt installed? should never fail
if [[ ! -f "$TMPFILE" ]] || [[ -s "$TMPFILE" ]] || [[ ! -d "$TMPDIR" ]]; then exit 1; fi

parallel-ssh \
	--timeout 0 \
	--outdir "$TMPDIR" \
	--hosts "$HOMELABDIR/pssh/all.hosts" \
	-O StrictHostKeyChecking=no \
	-O UserKnownHostsFile=/dev/null \
	-O GlobalKnownHostsFile=/dev/null \
	"$APT_COMMAND" >/dev/null || exit 1

i=0
# each file represents a different host's results
for FILE in "$TMPDIR"/*; do
	# if no upgrades, don't care don't notify
	if grep -q 'The following packages will be upgraded:' "$FILE"; then
		i=$((i+1))
		# replace apt's header with our own, includes the hostname
		{
			echo "Upgrades are available for ${FILE##*/}:"
			sed '1!b;/^The following packages will be upgraded:/d' "$FILE"
			echo '---'
		} >>"$TMPFILE"
	fi
done

if [[ $i -eq 0 ]]; then
	# no upgrades means no notification, cleanup and exit
	rm "$TMPFILE"
	rm -rf "$TMPDIR"
	exit 0
fi

BODY=""

COUNT=$(wc --chars "$TMPFILE" | awk '{print $1;}')
if [[ $COUNT -gt 1750 ]]; then
	BODY=$(cat <<-'EOD'
		Too many upgrades to list!
		Blame Discord for their character limits,
		then run in --single mode on each server manually
		EOD
); else
	BODY=$(head -n -1 "$TMPFILE") # cut off trailing seperator
fi

BODY="${BODY//$'\n'/\\n}" # escape newlines so json doesn't complain
truncate --size=0 "$TMPFILE" # probably not needed

# replaces bash-style variables with the actual value before curl sees it
envsubst < "$HOMELABDIR/scripts/apt-notif.json" >"$TMPFILE"
# the actual webhook magic
RESULT=$(curl --json "@$TMPFILE" \
              --retry 10 \
              --silent \
              --show-error \
              --url "https://notifiarr.com/api/v1/notification/passthrough/$APIKEY")
# dont care about the full response just pass/fail
RESULT=$(echo "${RESULT//$'\n'}" | jq --raw-output '.result')

# OS will take care of it if we crash but i don't like leaving files hanging around if i can help it
rm "$TMPFILE"
rm -rf "$TMPDIR"
if [[ $RESULT == 'success' ]]; then exit 0; else exit 1; fi
# ODOT: i should probably have some kind of solution for if this fails?
# 🤷‍♀️ whatever just set the exit code and figure it out later
