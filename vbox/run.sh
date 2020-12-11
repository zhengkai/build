#! /bin/bash -ex

# https://www.virtualbox.org/wiki/Linux_Downloads

exit

DIR=$(readlink -f "$0") && DIR=$(dirname "$DIR") && cd "$DIR" || exit 1

FILE='/etc/apt/sources.list.d/vbox.list'
echo "deb [arch=${ARCH}] https://download.virtualbox.org/virtualbox/debian ${CODENAME} contrib" \
	| sudo tee "$FILE"

sudo apt-key add oracle_vbox_2016.asc

# sudo apt-get install virtualbox-6.1
