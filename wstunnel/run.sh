#!/bin/bash

PACKAGE="erebe/wstunnel"

cd "$(dirname "$(readlink -f "$0")")" || exit 1

VER=$(./get-ver.sh "$PACKAGE") || VER="v1.21.2"

echo "$VER"

DST_BASE="/usr/local/src"

if [ ! -w "$DST_BASE" ]; then
	>&2 echo "no write permission to $DST_BASE"
	exit
fi

DST="${DST_BASE}/wstunnel-${VER}"
DST_FILE="${DST}/wstunnel"

ARCH="$(dpkg --print-architecture)"
FILE="wstunnel_${VER:1}_linux_${ARCH}.tar.gz"
URL="https://github.com/${PACKAGE}/releases/download/${VER}/${FILE}"

set -x

if [ ! -e "$DST" ]; then

	wget "$URL" -O "${DST_BASE}/${FILE}" || exit 1

	mkdir -p "$DST"

	tar -xvf "${DST_BASE}/${FILE}" -C "$DST"

	chmod +x "$DST_FILE" || exit 1
fi

FINAL_FILE="/usr/local/bin/wstunnel"

sudo cp "$DST_FILE" "${FINAL_FILE}-${VER}"

sudo ln -sf "${FINAL_FILE}-${VER}" "${FINAL_FILE}"
