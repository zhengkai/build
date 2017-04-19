#!/bin/bash

for TYPE in {local,server}; do
	NAME="ss-$TYPE"
	FILE="/etc/init.d/$NAME"

	echo 'remove '$NAME
	if [ -e $FILE ]; then
		sudo $FILE stop
		sudo update-rc.d $NAME remove
		sudo rm $FILE
	else
		sudo update-rc.d $NAME remove
	fi
done
