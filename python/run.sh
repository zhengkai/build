#!/bin/bash -ex

VER=$($(dirname "$0")"/get-ver.sh")
#VER="3.8.1"

sudo apt install libffi-dev

BASE_DIR="/usr/local/src/python-${VER}"

SRC_FILE="${BASE_DIR}.tar.xz"
if [ ! -f "$SRC_FILE" ]; then
	wget 'https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tar.xz' -O "$SRC_FILE"
fi

SRC_DIR="${BASE_DIR}"
if [ ! -d "$SRC_DIR" ]; then
	mkdir -p "$SRC_DIR"
	tar xf "$SRC_FILE" -C "$SRC_DIR" --strip-components=1
fi
cd "$SRC_DIR"

make clean >/dev/null 2>&1 || :

./configure --enable-optimizations
make
sudo make install

PIP='/usr/local/bin/pip'
rm "$PIP" >/dev/null 2>1 || :
sudo ln -s '/usr/local/bin/pip3' "$PIP"

BIN='/usr/local/bin/python'
rm "$BIN" >/dev/null 2>1 || :
sudo ln -s '/usr/local/bin/python3' "$BIN"
