#!/bin/bash

PROJ="kovidgoyal/kitty"

RELEASE_FILE="ver/releases.json"

cd "$(dirname "$(readlink -f "$0")")" || exit 1

LOCKFILE="./update-ver.lock"
exec 200>$LOCKFILE
flock -n 200 || exit 1

mkdir -p ver

if [ -e "$RELEASE_FILE" ]; then
	rm "$RELEASE_FILE"
fi
wget "https://api.github.com/repos/${PROJ}/releases" -O "$RELEASE_FILE"

# jq . "$RELEASE_FILE"

CURRENT=$(jq -r '.[] | .name' "$RELEASE_FILE" | grep -Po 'version \K[\d\.]+' | sort -Vr | head -n 1 | tee ver/current.txt)
echo "$CURRENT"
