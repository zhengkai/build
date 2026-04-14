#!/usr/bin/env bash

PACKAGE="shadowsocks/shadowsocks-rust"

cd "$(dirname "$(readlink -f "$0")")" || exit 1

VER=$(./get-ver.sh "$PACKAGE") || VER="v1.21.2"

echo "$VER"

DST_BASE="/usr/local/src"

if [ ! -w "$DST_BASE" ]; then
	>&2 echo "no write permission to $DST_BASE"
	exit
fi

FILE="shadowsocks-${VER}.$(arch)-unknown-linux-musl.tar.xz"
URL="https://github.com/${PACKAGE}/releases/download/${VER}/${FILE}"

wget "$URL" -O "${DST_BASE}/${FILE}" || exit 1

DST="${DST_BASE}/ss-rust-${VER}"
mkdir -p "$DST"

tar -xvf "${DST_BASE}/${FILE}" -C "$DST"

FILE_LIST=("sslocal" "ssmanager" "ssserver" "ssservice" "ssurl")
for FILE in "${FILE_LIST[@]}"; do
	sudo cp "${DST}/${FILE}" /usr/local/bin/
done

hash -r
