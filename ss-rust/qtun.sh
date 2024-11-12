#!/bin/bash

PACKAGE="shadowsocks/qtun"

cd "$(dirname "$(readlink -f "$0")")" || exit 1

VER=$(./get-ver.sh "$PACKAGE") || VER="v0.2.0"

echo "$VER"

DST_BASE="/usr/local/src"

if [ ! -w "$DST_BASE" ]; then
	>&2 echo "no write permission to $DST_BASE"
	exit
fi

FILE="qtun-${VER}.$(arch)-unknown-linux-musl.tar.xz"
URL="https://github.com/${PACKAGE}/releases/download/${VER}/${FILE}"

wget "$URL" -O "${DST_BASE}/${FILE}" || exit 1

DST="${DST_BASE}/qtun-${VER}"
mkdir -p "$DST"

tar -xvf "${DST_BASE}/${FILE}" -C "$DST"

FILE_LIST=("qtun-client" "qtun-server")
for FILE in "${FILE_LIST[@]}"; do
	sudo cp "${DST}/${FILE}" /usr/local/bin/
done

hash -r
