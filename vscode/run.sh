#!/bin/bash

if [ -z "$DISPLAY" ]; then
	echo "This script must be run in a graphical environment."
	exit 1
fi

if [ -e /usr/share/code/code ]; then
	echo "/usr/share/code/code exists"
	exit
fi

FILE="/usr/local/src/vscode.deb"

wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
	-O "$FILE" || exit 1

sudo dpkg -i "$FILE"
