#!/bin/bash -e

cd $(dirname `readlink -f $0`)

(
	flock -x -n 200 || exit 1

	CURRENT_VER=''

	VER_FILE='ver.txt'
	if [ -f "$VER_FILE" ]; then
		CURRENT_VER=`cat ver.txt`
	fi

	CHECK_VER=`./get-ver.sh`

	if [ "$CURRENT_VER" == "$CHECK_VER" ]; then
		echo
		echo 'newest version '$CHECK_VER', no need update'
		echo
		exit
	fi

	./bin.sh

	echo $CHECK_VER > $VER_FILE

) 200>update_bin.lock
