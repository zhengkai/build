#! /bin/bash -ex

SRC_DIR='/usr/local/src'
GIT_SRC_DIR=$SRC_DIR'/watchman'

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1
LOCK_FILE="${DIR}/update.lock"
VER_FILE="${DIR}/ver.txt"

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	>&2 echo 'no dir '$GIT_SRC_DIR
	exit 1
fi

cd "$SRC_DIR"

if [ ! -e "$GIT_SRC_DIR" ]; then
	git clone https://github.com/facebook/watchman.git "$GIT_SRC_DIR"
fi
cd $GIT_SRC_DIR

if [ "$('pwd')" != $GIT_SRC_DIR ]; then
	>&2 echo 'fail to cd '$GIT_SRC_DIR
	exit 1
fi

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

	sudo apt-get install -y --no-install-recommends \
		automake \
		build-essential \
		pkg-config \
		libtool

	git checkout "v${VER}"

	make clean 2>&1 || :
	./autogen.sh
	./configure
	make
	sudo make install

	echo "$VER" > "$VER_FILE"

) 200>"$LOCK_FILE"
