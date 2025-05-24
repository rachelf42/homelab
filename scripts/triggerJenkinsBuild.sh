#!/bin/bash

if [[ -n "$JENKINS_HOOK_TOKEN" ]]; then
	echo "MISSING TOKEN"
	exit 255
elif [[ -n "$JENKINS_HOOK_URL" ]]; then
	echo "MISSING URL"
	exit 255
elif [[ "${JENKINS_HOOK_URL:0:4}" != "http" ]]; then # basic sanity check only
	echo "BAD URL"
	exit 255
fi

echo "Sending Webhook"
RESPONSE=$(curl \
	--fail-with-body \
	--silent \
	--form-string "job=$1" \
	--form-string "token=$JENKINS_HOOK_TOKEN" \
	--write-out "%{response_code}" \
	"$JENKINS_HOOK_URL")
EXITCODE=$?
echo "Jenkins says: $RESPONSE"
echo "cURL says: $EXITCODE"
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
