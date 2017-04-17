#!/bin/bash -e

if [ -z "$VER_CHOOSE" ]; then
	VER_CHOOSE='LTS'
fi
# VER_CHOOSE='Current'

INSTALL_DIR='/usr/local/'
SRC_DIR='/usr/local/src/'

SCRIPT_DIR="$( cd "`dirname "$0"`" && pwd )"
LOCK_FILE=$SCRIPT_DIR'/update.lock'
VER_FILE=$SCRIPT_DIR'/ver.txt'

VER=`curl -s https://nodejs.org/en/ | grep -Po 'Download v\d+\.\d+(\.\d+)? '$VER_CHOOSE | cut -d 'v' -f 2 | cut -d ' ' -f 1`

if [ -z "$VER" ]; then
	>&2 echo 'cannot detect version'
	exit 1
fi

FILE='node-v'$VER'-linux-x64.tar.xz'
FILE_DIR=$SRC_DIR'node-v'$VER
URL='https://nodejs.org/dist/v'$VER'/'$FILE

(
	flock -x -n 200 || exit 1

	PREV_VER=''
	if [ -f $VER_FILE ]; then
		PREV_VER=`cat $VER_FILE`
	fi

	if [ "$VER" == "$PREV_VER" ]; then
		>&2 echo 'newest version '$VER', no need update'
		exit 1
	fi

	wget $URL -O $SRC_DIR$FILE
	mkdir -p $FILE_DIR
	tar -xf $SRC_DIR$FILE -C $FILE_DIR --strip-components=1

	SUB_DIR=('bin' 'include' 'lib' 'share')
	for i in "${SUB_DIR[@]}"; do
		sudo cp -r $FILE_DIR'/'$i $INSTALL_DIR
	done

	echo "$VER" > $VER_FILE

) 200>$LOCK_FILE
