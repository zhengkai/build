#!/usr/bin/env bash

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

cd "$(dirname "$(readlink -f "$0")")" || exit 1

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo "unknown arch $ARCH"
	exit
fi

GPG_FILE="/usr/share/keyrings/mongodb-server-7.0.gpg"

if [ ! -e "$GPG_FILE" ]; then
	curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
		sudo gpg -o "$GPG_FILE" \
		--dearmor
fi

CODENAME=$(lsb_release -c -s)

LIST_FILE="/etc/apt/sources.list.d/mongodb-org-7.0.list"

if [ ! -e "$LIST_FILE" ]; then
	echo "deb [ arch=${ARCH} signed-by=${GPG_FILE} ] https://repo.mongodb.org/apt/ubuntu ${CODENAME}/mongodb-org/7.0 multiverse" \
		| sudo tee "$LIST_FILE"
fi

sudo apt update

sudo apt install -y mongodb-org

./hold.sh
