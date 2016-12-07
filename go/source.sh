#!/bin/bash -ex

GOBIN_VER='1.7.3'
SRC_PATH='/usr/local/src'

cd $SRC_PATH
if ! [ $(pwd) == $SRC_PATH ]; then
	echo 'can enter dir '$SRC_PATH >&2
	exit
fi

GOBIN_NAME='go'$GOBIN_VER'.linux-amd64.tar.gz'
GOBIN_FILE=$SRC_PATH'/'$GOBIN_NAME
if ! [ -e $GOBIN_FILE ]; then
	wget 'https://storage.googleapis.com/golang/'$GOBIN_NAME -O $GOBIN_FILE
fi

GOBIN_DIR=$SRC_PATH'/gobin'$GOBIN_VER
if ! [ -e $GOBIN_DIR'/LICENSE' ]; then
	mkdir -p $GOBIN_DIR
	tar -xf $GOBIN_FILE -C $GOBIN_DIR --strip-components=1
fi

GOSRC_DIR=$SRC_PATH'/go'
if ! [ -e $GOSRC_DIR ]; then
	git clone https://github.com/golang/go $GOSRC_DIR
fi

cd $GOSRC_DIR'/src'
GOROOT_BOOTSTRAP=$GOBIN_DIR ./clean.bash || echo 'clean'
GOROOT_BOOTSTRAP=$GOBIN_DIR ./all.bash
