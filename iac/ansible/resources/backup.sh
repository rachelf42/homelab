#!/bin/bash
# this script will bring down the current Docker Compose project, backup the appdata folder, and bring it back up
# it will then rsync the resulting tarball over to central storage, and lastly prune the local folder using python3-timegaps
# note that it does not prune the remote side, just local. it also relies on /etc/environment to configure compose for it
# cause it just calls the raw up/down command without any arguments other than --detach

#TODO test then uncomment timegaps
#TODO figure out what we wanna do for remote side pruning

if [[ "$EUID" -ne 0 ]]
	then echo 'Please run as root'
	exit 1
fi

RSYNC_HOST=${RSYNC_HOST:-nas1.local.rachelf42.ca}
RSYNC_DEST="$RSYNC_HOST:/home/rachel/homelab-backups"

# INTERNAL VARIABLES
CHOWN="$DOCKER_USER:$DOCKER_USER"
TIMESTAMP=$(date +%s) #UNIX timestamp
FILENAME="appdata-$HOSTNAME-$TIMESTAMP.tar.gz"

cd "$DOCKERDIR" || exit 1
docker compose --progress quiet down
tar --create --auto-compress --file="./backups/$FILENAME" "./appdata"
chown "$CHOWN" "./backups/$FILENAME"
docker compose --progress quiet up -d
rsync \
	--rsh='ssh' \
	--archive \
	--safe-links \
	--quiet \
	--ignore-existing \
	--exclude=README.md \
	'./backups/' \
	"$DOCKER_USER@$RSYNC_DEST"
#timegaps --delete days3,weeks3,months3,years3 ./backups
