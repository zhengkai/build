#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

# VER=$(./get-ver.sh)
VER=${VER:-v1.21.2}

echo "$VER"

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo "unknown arch $ARCH"
	exit
fi

DST_BASE="/usr/local/src"
if [ ! -w "$DST_BASE" ]; then
	>&2 echo "no write permission to $DST_BASE"
	exit
fi

FILE="shadowsocks-${VER}.x86_64-unknown-linux-musl.tar.xz"
URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/${VER}/${FILE}"

wget "$URL" -O "${DST_BASE}/${FILE}" || exit 1

DST="${DST_BASE}/ss-rust-${VER}"
mkdir -p "$DST"

tar -xvf "${DST_BASE}/${FILE}" -C "$DST"

sudo cp "${DST}"/ss* /usr/local/bin/
