#!/bin/bash
# TODO: change to pull from NAS
# Issue URL: https://github.com/rachelf42/homelab/issues/48
# labels: waiting, hideFromCodeEditor
rsync \
--rsh "ssh \
-o StrictHostKeyChecking=no \
-o UserKnownHostsFile=/dev/null \
-i $HOMELAB_JENKINS_SECRETSYNC_KEY" \
--archive --verbose --compress \
"$HOMELAB_JENKINS_SECRETSYNC_USER"@rachel-pc.local.rachelf42.ca:/home/rachel/homelab/secrets/ secrets