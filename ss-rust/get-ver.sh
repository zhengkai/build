#!/bin/bash

RELEASE_FILE="ver/releases.json"

cd "$(dirname "$(readlink -f "$0")")" || exit 1

LOCKFILE="./update-ver.lock"

(

flock -n 200 || exit 1

mkdir -p ver

if [ -e "$RELEASE_FILE" ]; then
	rm "$RELEASE_FILE"
fi
wget 'https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases' -O "$RELEASE_FILE"

jq -r '.[] | .name' "$RELEASE_FILE" |  sort -Vr | head -n 1 | tee ver/current.txt

) 200>${LOCKFILE}
