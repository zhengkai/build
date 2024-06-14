#!/bin/bash -ex

VER="0.34.1"

mkdir -p /usr/local/src/kitty-bin
cd /usr/local/src/kitty-bin

FILE="kitty-${VER}-x86_64.txz"

if [ ! -e "$FILE" ]; then
	wget "https://github.com/kovidgoyal/kitty/releases/download/v${VER}/${FILE}" \
		-O "$FILE"
fi

mkdir "$VER"
cd "$VER"
tar Jxvf "../${FILE}"

if [ ! -e bin/kitty ] || [ ! -e share/man/man5/kitty.conf.5 ]; then
	exit 1
fi

sudo rsync --partial -vzrtopg share /usr/local/

DIR="$(pwd)"

sudo ln -s "${DIR}/bin/kitty" /usr/local/bin
sudo ln -s "${DIR}/bin/kitten" /usr/local/bin
