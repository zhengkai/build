#! /bin/bash -ex

# https://www.virtualbox.org/wiki/Linux_Downloads

cd "$(dirname "$(readlink -f "$0")")" || exit 1

CODENAME=$(lsb_release -c -s)

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo "unknown arch $ARCH"
	exit
fi

GPG_TARGET="/usr/share/keyrings/oracle-virtualbox-2016.gpg"

# sudo gpg --yes --output oracle_vbox_2016.gpg --dearmor oracle_vbox_2016.asc
sudo cp oracle_vbox_2016.gpg "$GPG_TARGET"

FILE='/etc/apt/sources.list.d/vbox.list'
echo "deb [arch=${ARCH} signed-by=${GPG_TARGET}] https://download.virtualbox.org/virtualbox/debian ${CODENAME} contrib" \
	| sudo tee "$FILE"
