#!/bin/bash -e

SRC_DIR="/usr/local/src"
SS_SRC_DIR="${SRC_DIR}/simple-obfs"

if [ ! -d "$SRC_DIR" ] || [ ! -w "$SRC_DIR" ]; then
	>&2 echo "no dir $SRC_DIR"
	exit 1
fi

if [ ! -d "$SS_SRC_DIR" ]; then
	git clone https://github.com/shadowsocks/simple-obfs.git "$SS_SRC_DIR"
fi
cd "$SS_SRC_DIR"

git reset --hard
git checkout master
git pull

sudo apt-get install -y --no-install-recommends \
	build-essential \
	autoconf \
	libtool \
	libssl-dev \
	libpcre3-dev \
	libev-dev \
	asciidoc \
	xmlto \
	automake

#git checkout v0.0.5

git submodule update --init --recursive

make clean 2>&1 || :
./autogen.sh
./configure --disable-documentation
make
sudo make install
