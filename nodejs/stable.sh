#!/bin/bash -e

if [ -z "$VER_CHOOSE" ]; then
	VER_CHOOSE='LTS'
fi
# VER_CHOOSE='Current'

INSTALL_DIR='/usr/local/'
SRC_DIR='/usr/local/src'
if [ ! -w "$SRC_DIR" ]; then
	>&2 echo "dir $SRC_DIR can not write"
	exit 1
fi

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

LOCK_FILE="${DIR}/update.lock"
VER_FILE="${DIR}/ver.txt"

VER=$(curl -s https://nodejs.org/en/ | grep -Po "Download \d+\.\d+(\.\d+)? ${VER_CHOOSE}" | cut -d ' ' -f 2)
if [ -z "$VER" ]; then
	>&2 echo 'cannot detect version'
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
FILE_DIR="${SRC_DIR}/node-v${VER}"
URL="https://nodejs.org/dist/v${VER}/${FILE}"

echo "$URL"

exec 200>"$LOCK_FILE"
flock -x -n 200 || {
	>&2 echo
	>&2 echo "$0 is running"
	exit 1
}

PREV_VER=''
if [ -f "$VER_FILE" ]; then
	PREV_VER=$(cat "$VER_FILE")
fi

if [ "$VER" == "$PREV_VER" ]; then
	>&2 echo "newest version $VER, no need update"
	exit 1
fi

SAVE_FILE="${SRC_DIR}/${FILE}"
if [ -e "$SAVE_FILE" ]; then
    rm "$SAVE_FILE"
fi
wget "$URL" -O "$SAVE_FILE"

mkdir -p "$FILE_DIR"
tar -xf "${SAVE_FILE}" -C "$FILE_DIR" --strip-components=1

mv "${FILE_DIR}/bin/node" "${FILE_DIR}/bin/node-${VER}"

sudo rm -rf "${INSTALL_DIR}/lib/node_modules" || :

SUB_DIR=('bin' 'include' 'lib' 'share')
for i in "${SUB_DIR[@]}"; do
	sudo cp -R "${FILE_DIR}/${i}" "$INSTALL_DIR"
done

sudo ln -sf "${INSTALL_DIR}bin/node-${VER}" "${INSTALL_DIR}bin/node"
sudo ln -sf "${INSTALL_DIR}bin/node-${VER}" "${INSTALL_DIR}bin/nodejs"

"$DIR/acl.sh"

echo "$VER" > "$VER_FILE"
