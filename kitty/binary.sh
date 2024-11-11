#!/bin/bash -ex

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo "unknown arch $ARCH"
	exit
fi

cd "$(dirname "$(readlink -f "$0")")" || exit 1

./get-ver.sh

VER="$(cat ver/current.txt || :)"
VER="${VER:-0.36.4}"

mkdir -p /usr/local/src/kitty-bin
cd /usr/local/src/kitty-bin

FILE="kitty-${VER}-${ARCH}.txz"

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

sudo ln -sf "${DIR}/bin/kitty" /usr/local/bin
sudo ln -sf "${DIR}/bin/kitten" /usr/local/bin
