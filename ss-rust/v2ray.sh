#!/bin/bash -ex

PACKAGE="shadowsocks/v2ray-plugin"

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

VER=$(./get-ver.sh "$PACKAGE") || VER="v1.3.2"

echo "$VER"

DST_BASE="/usr/local/src"

if [ ! -w "$DST_BASE" ]; then
	>&2 echo "no write permission to $DST_BASE"
	exit
fi

FILE="v2ray-plugin-linux-${ARCH}-${VER}.tar.gz"
URL="https://github.com/${PACKAGE}/releases/download/${VER}/${FILE}"

wget "$URL" -O "${DST_BASE}/${FILE}" || exit 1

DST="${DST_BASE}/qtun-${VER}"
mkdir -p "$DST"

tar -xvf "${DST_BASE}/${FILE}" -C "$DST"

sudo cp "${DST}/v2ray-plugin_linux_${ARCH}" /usr/local/bin/v2ray-plugin

hash -r
