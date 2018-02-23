#!/bin/bash -x

cd $(dirname `readlink -f $0`)
GOBIN_VER=`./get_ver.sh`

if [ -z "$GOBIN_VER" ]; then
	>&2 echo 'can not detect go version'
	exit 1
fi

GOBIN_NAME='go'$GOBIN_VER'.linux-amd64.tar.gz'
GOBIN_FILE='/tmp/'$GOBIN_NAME
if ! [ -e $GOBIN_FILE ]; then
	wget 'https://dl.google.com/go/'$GOBIN_NAME -O $GOBIN_FILE
fi

if [ -e /usr/local/go ]; then
	sudo rm -rf /usr/local/go
fi
sudo tar -C /usr/local -xzf $GOBIN_FILE
