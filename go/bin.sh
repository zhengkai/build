#!/bin/bash -ex

# https://golang.org/dl/

GOBIN_VER='1.7.4'

GOBIN_NAME='go'$GOBIN_VER'.linux-amd64.tar.gz'
GOBIN_FILE='/tmp/'$GOBIN_NAME
if ! [ -e $GOBIN_FILE ]; then
	wget 'https://storage.googleapis.com/golang/'$GOBIN_NAME -O $GOBIN_FILE
fi

if [ -e /usr/local/go ]; then
	sudo rm -rf /usr/local/go
fi
sudo tar -C /usr/local -xzf $GOBIN_FILE
