#!/bin/bash

ALLOW_HOST="Monk Enigma"

echo "$HOSTNAME"
if ! echo "$ALLOW_HOST" | grep -qw "$HOSTNAME"; then
	exit 1
fi

set -x
sudo sed -i \
	"s#^ExecStart.*#ExecStart=-/sbin/agetty -a zhengkai --noclear %I \$TERM#" \
	/lib/systemd/system/getty@.service
