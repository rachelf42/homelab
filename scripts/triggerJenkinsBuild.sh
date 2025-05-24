#!/bin/bash
echo "Sending Webhook"
RESPONSE=$(curl \
	--fail-with-body \
	--silent \
	--form-string "job=$1" \
	--form-string "token=$2" \
	--write-out "%{response_code}" \
	"$3")
if [[ $RESPONSE == 201 ]]; then
	echo 'Queued Successfully'
	exit 0
elif [[ $RESPONSE == 303 ]]; then
	echo 'Build Already Scheduled'
	exit 1
else
	echo 'Unknown Error'
	exit 255
fi