#!/bin/bash
# vim: set noexpandtab
# pretty simple script, just git pull; docker compose pull; docker compose up
# it retries the pull up to 3 times before giving up with exit 1 and letting the user figure it out from there
# did that instead of --pull=always cause sometimes it just fails? for no reason? so the retry'll fix that
# rest of the file is just selecting whether to output anything or not

RSYNC_HOST=${RSYNC_HOST:-rachel-pc.local.rachelf42.ca}

cd "$DOCKERDIR" || exit 1

Q=''
# if tty is attached then assume loud else assume quiet
if tty -s; then SHH=false; else SHH=true; fi
# if user specified then override
if [[ "$1" = '-q' ]]; then SHH=true; fi
if [[ "$1" = '--quiet' ]]; then SHH=true; fi
if [[ "$1" = '--loud' ]]; then SHH=false; fi

if $SHH; then Q='--quiet'; fi
if [[ "$USER" == "$DOCKER_USER" ]]; then
	git pull $Q 2>&1 || exit 1
else
	su "$DOCKER_USER" -c "git pull $Q 2>&1" || exit 1
fi

rsync \
	--archive \
	--delete-delay \
	$Q "$DOCKER_USER@$RSYNC_HOST:$DOCKERDIR/secrets/" "$DOCKERDIR/secrets/" || exit 1

if $SHH; then Q='--progress=quiet'; fi
for i in {1..3}; do
	if (docker compose $Q pull 2>&1); then
		break
	else
		if [[ $i = 3 ]]; then
			echo 'ERROR: Pull failed 3 times' 1>&2
			exit 1
		else
			echo 'WARN: Pull failed, retrying in 30s' 1>&2
			sleep 30
		fi
	fi
done

docker compose $Q up --detach --remove-orphans --pull never 2>&1 || exit 1

if $SHH; then exec &>/dev/null; fi
# /!\ DANGER, WILL ROBINSON, DANGER /!\
docker system prune --force --volumes 2>&1
