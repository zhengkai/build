#!/bin/bash -e

if [ -z "$VER_CHOOSE" ]; then
	VER_CHOOSE='LTS'
fi
# VER_CHOOSE='Current'

INSTALL_DIR='/usr/local/'
SRC_DIR='/usr/local/src/'

SCRIPT_DIR="$( cd "`dirname "$0"`" && pwd )"
LOCK_FILE="${SCRIPT_DIR}/update.lock"
VER_FILE="${SCRIPT_DIR}/ver.txt"

VER=`curl -s https://nodejs.org/en/ | grep -Po "Download \d+\.\d+(\.\d+)? ${VER_CHOOSE}" | cut -d ' ' -f 2`

if [ -z "$VER" ]; then
	>&2 echo 'cannot detect version'
	exit 1
fi

ARCH=`arch`
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='x64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo unknown arch $ARCH
	exit
fi

FILE="node-v${VER}-linux-${ARCH}.tar.xz"
FILE_DIR="${SRC_DIR}node-v${VER}"
URL="https://nodejs.org/dist/v${VER}/${FILE}"

echo $URL

(
	flock -x -n 200 || exit 1

	PREV_VER=''
	if [ -f $VER_FILE ]; then
		PREV_VER=`cat $VER_FILE`
	fi

	if [ "$VER" == "$PREV_VER" ]; then
		>&2 echo 'newest version '$VER', no need update'
		exit 1
	fi

	SAVE_FILE="${SRC_DIR}${FILE}"
	if [ -e "$SAVE_FILE" ]; then
	    rm "$SAVE_FILE"
	fi
	wget "$URL" -O "$SAVE_FILE"

	mkdir -p "$FILE_DIR"
	tar -xf "${SAVE_FILE}" -C "$FILE_DIR" --strip-components=1

	SUB_DIR=('bin' 'include' 'lib' 'share')
	for i in "${SUB_DIR[@]}"; do
		sudo cp -R "${FILE_DIR}/${i}" "$INSTALL_DIR"
	done

	if [ ! -e "${INSTALL_DIR}bin/nodejs" ]; then
		sudo ln -s "${INSTALL_DIR}bin/node" "${INSTALL_DIR}bin/nodejs"
	fi

	echo "$VER" > "$VER_FILE"

) 200>"$LOCK_FILE"
