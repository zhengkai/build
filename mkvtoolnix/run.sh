#!/bin/bash -e

GPG_FILE="/usr/share/keyrings/mkvtoolnix.gpg"

REPO_URL="https://mkvtoolnix.download/ubuntu/"

CODENAME=$(lsb_release -c -s)

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo unknown arch $ARCH
	exit
fi

cd "$(dirname "$(readlink -f "$0")")" || exit 1

if [ ! -e "$GPG_FILE" ]; then
	sudo cp mkvtoolnix.gpg "$GPG_FILE"
fi

SOURCE='source.list'

REPO="[arch=${ARCH} signed-by=${GPG_FILE}] $REPO_URL $CODENAME main"

echo "deb $REPO" > "$SOURCE"
echo "deb-src $REPO" >> "$SOURCE"
cat "$SOURCE"
sudo cp "$SOURCE" /etc/apt/sources.list.d/mkvtoolnix.list

sudo apt update
sudo apt install mkvtoolnix mkvtoolnix-gui
