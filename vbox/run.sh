#! /bin/bash -ex

# https://www.virtualbox.org/wiki/Linux_Downloads

DIR=$(readlink -f "$0") && DIR=$(dirname "$DIR") && cd "$DIR" || exit 1

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

FILE='/etc/apt/sources.list.d/vbox.list'
echo "deb [arch=${ARCH}] https://download.virtualbox.org/virtualbox/debian ${CODENAME} contrib" \
	| sudo tee "$FILE"

sudo apt-key add oracle_vbox_2016.asc

# sudo apt-get install virtualbox-6.1
