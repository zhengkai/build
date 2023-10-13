#!/bin/bash -e

SRC_DIR='/usr/local/src'
SS_SRC_DIR="${SRC_DIR}/shadowsocks"

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

LOCK_FILE="${DIR}/update.lock"
VER_FILE="${DIR}/ver.txt"

if [ ! -d "$SRC_DIR" ] || [ ! -w "$SRC_DIR" ]; then
	>&2 echo no dir $SRC_DIR
	exit 1
fi

if [ ! -e "$SS_SRC_DIR" ]; then
	git clone https://github.com/shadowsocks/shadowsocks-libev.git "$SS_SRC_DIR"
fi
cd "$SS_SRC_DIR"

(
	flock -x -n 200 || exit 1

	git reset --hard
	git checkout master
	git pull

	PREV_VER=''
	if [ -f "$VER_FILE" ]; then
		PREV_VER=$(cat "$VER_FILE")
	fi

	VER=$(git ls-remote --tags | grep -o 'refs/tags/v.*' | grep -v '\^' | grep -v '\[a-z\]+' | cut -d '/' -f 3 | cut -d 'v' -f 2 | grep -v '[a-zA-Z]' | sort -b -t . -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr -k5,5nr | head -n 1)
	if [ -z "$VER" ]; then
		>&2 echo 'can`t get release tags'
		exit 1
	fi

	if [ "$VER" == "$PREV_VER" ]; then
		>&2 echo "newest version ${VER}, no need update"
		exit 1
	fi

	if [ -z "$PREV_VER" ]; then
		sudo apt-get install -y --no-install-recommends \
			automake build-essential gettext libtool libc-ares-dev \
			libpcre3-dev asciidoc xmlto libmbedtls-dev libev-dev \
			libudns-dev libsodium-dev
	fi

	git checkout "v${VER}"

	git submodule update --init --recursive

	make clean 2>&1 || :
	./autogen.sh
	./configure
	make

	if [ "$1" == 'kill' ]; then
		"${DIR}/kill.sh"
	fi

	sudo make install

	echo "$VER" > "$VER_FILE"

	# if [ -x /etc/init.d/ss-local ]; then
	# 	sudo /etc/init.d/ss-local restart || :
	# fi
	# if [ -x /etc/init.d/ss-server ]; then
	# 	sudo /etc/init.d/ss-server restart || :
	# fi

	if [ ! -e /usr/local/bin/obfs-server ]; then
		"${DIR}/obfs.sh"
	fi

) 200>"$LOCK_FILE"
