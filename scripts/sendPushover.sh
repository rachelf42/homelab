#!/bin/bash
PRIORITY="$1"
MESSAGE="${*:2}"
curl \
	--form-string "token=$APP_TOKEN" \
	--form-string "user=$USER_KEY" \
	--form-string "message=$MESSAGE" \
	--form-string "device=Rachel-Opera,Rachel-A13" \
	--form-string "priority=$PRIORITY" \
	--form-string "url=$BUILD_URL" \
	--form-string "url_title=View $BUILD_TAG" \
	https://api.pushover.net/1/messages.json
exit $?