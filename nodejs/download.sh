#!/bin/bash

VER="$1"
if [ -z "$VER" ]; then
	>&2 echo 'empty ver'
	exit
fi

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

LOCKFILE="${DIR}/update-bin.lock"
exec 200>"$LOCKFILE"
flock -n 200 || exit 1

VER_FILE="${DIR}/ver/last.txt"
LAST_VER="$(cat "$VER_FILE" || :)"
if [ "$LAST_VER" == "$VER" ]; then
	>&2 echo "newest version '$VER', no need update"
	exit
fi

INSTALL_DIR='/usr/local/'
SRC_DIR='/usr/local/src'
if [ ! -w "$SRC_DIR" ]; then
	>&2 echo "dir $SRC_DIR can not write"
	exit 1
fi

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='x64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo unknown arch $ARCH
	exit
fi

FILE="node-v${VER}-linux-${ARCH}.tar.xz"
URL="https://nodejs.org/dist/v${VER}/${FILE}"

echo "$URL"

SAVE_FILE="${SRC_DIR}/${FILE}"
if [ -e "$SAVE_FILE" ]; then
    rm "$SAVE_FILE"
fi
wget "$URL" -O "$SAVE_FILE" || exit 1

FILE_DIR="${SRC_DIR}/node-v${VER}"
mkdir -p "$FILE_DIR"
tar -xf "${SAVE_FILE}" -C "$FILE_DIR" --strip-components=1
mv "${FILE_DIR}/bin/node" "${FILE_DIR}/bin/node-${VER}"

sudo rm -rf "${INSTALL_DIR}lib/node_modules" || :

SUB_DIR=('bin' 'include' 'lib' 'share')
for i in "${SUB_DIR[@]}"; do
	sudo cp -R "${FILE_DIR}/${i}" "$INSTALL_DIR"
done

sudo ln -sf "${INSTALL_DIR}bin/node-${VER}" "${INSTALL_DIR}bin/node"
sudo ln -sf "${INSTALL_DIR}bin/node-${VER}" "${INSTALL_DIR}bin/nodejs"

pwd
"$DIR/acl.sh"

echo "$VER" > "$VER_FILE"
