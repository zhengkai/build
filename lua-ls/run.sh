#!/bin/bash -ex

VER="3.13.6"

SRC_DIR='/usr/local/src'

ARCH=$(arch)
if [ "$ARCH" == "x86_64" ]; then
	ARCH="x64"
elif  [ "$ARCH" == "aarch64" ]; then
	ARCH="arm64"
else
	>&2 echo "unknown arch $ARCH"
	exit
fi

FILE="lua-language-server-${VER}-linux-${ARCH}.tar.gz"

FILE_LOCAL="${SRC_DIR}/${FILE}"
URL="https://github.com/LuaLS/lua-language-server/releases/download/${VER}/${FILE}"
if [ ! -f "$FILE_LOCAL" ]; then
	wget "$URL" -O "$FILE_LOCAL"
fi

DIR="${SRC_DIR}/lua-ls-${VER}"
rm -rf "$DIR" || :
mkdir -p "$DIR"
cd "$DIR" || exit 1
tar xzf "$FILE_LOCAL" -C "$DIR"

LIB_DIR="/usr/local/lib/lua-ls"
sudo rm -rf "$LIB_DIR"
sudo mv "$DIR" "$LIB_DIR"

sudo ln -sf "${LIB_DIR}/bin/lua-language-server" "/usr/local/bin/"
