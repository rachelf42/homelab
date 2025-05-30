#!/bin/bash
PRIORITY="$1"
MESSAGE="${*:2}"
if [[ $PRIORITY -gt 0 ]]; then
	SOUND=rachel-hiprio
else
	SOUND=rachel-loprio
fi
curl --fail-with-body --silent \
	--form-string "token=$APP_TOKEN" \
	--form-string "user=$USER_KEY" \
	--form-string "message=$MESSAGE" \
	--form-string "device=Rachel-Opera,Rachel-A13" \
	--form-string "priority=$PRIORITY" \
	--form-string "sound=$SOUND" \
	--form-string "url=${BUILD_URL}console" \
	--form-string "url_title=View $BUILD_TAG Console" \
	https://api.pushover.net/1/messages.json
exit $?
