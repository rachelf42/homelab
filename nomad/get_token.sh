#!/bin/sh
# TODO: do this properly with like vault or something
# use with `export NOMAD_TOKEN=$(./get_token.sh)`
ansible-vault decrypt ../secrets/nomad.token 1>&2 && \
	cat ../secrets/nomad.token
ansible-vault encrypt ../secrets/nomad.token 1>&2
exit $?