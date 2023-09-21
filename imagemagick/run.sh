#! /bin/bash -ex

SRC_DIR='/usr/local/src'

IM_SRC_DIR="${SRC_DIR}/imagemagick"

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1
LOCK_FILE="${DIR}/update.lock"
VER_FILE="${DIR}/ver.txt"

if [ ! -d "$SRC_DIR" ] || [ ! -w "$SRC_DIR" ]; then
	>&2 echo no dir $IM_SRC_DIR
	exit 1
fi

cd "$SRC_DIR"
if [ "$('pwd')" != "$SRC_DIR" ]; then
	>&2 echo fail to cd $SRC_DIR
	exit 1
fi

if [ ! -e "$IM_SRC_DIR" ]; then
	git clone https://github.com/ImageMagick/ImageMagick.git "$IM_SRC_DIR"
fi
cd $IM_SRC_DIR
if [ "$('pwd')" != "$IM_SRC_DIR" ]; then
	>&2 echo fail to cd $IM_SRC_DIR
	exit 1
fi

(
	flock -x -n 200 || exit 1

	git reset --hard
	git checkout main
	git pull

	PREV_VER=''
	if [ -f "$VER_FILE" ]; then
		PREV_VER=$(cat "$VER_FILE")
	fi

	# VER=`git ls-remote --tags | grep -o 'refs/tags/[0-9].*' | grep -v '\^' | grep -v '\[a-z\]+' | cut -d '/' -f 3 | cut -d 'v' -f 2 | grep -v '[a-zA-Z]' | sort -b -t . -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr -k5,5nr | head -n 1`
	# VER=`git ls-remote --tags | grep -o 'refs/tags/[0-9].*' | grep -v '\^' | grep -v '\[a-z\]+' | cut -d '/' -f 3 | grep -v '[a-zA-Z]' | sort -b -t . -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr -k5,5nr | head -n 1`
	VER=$(git ls-remote --tags | grep -o 'refs/tags/[0-9].*' | grep -v '\^' | grep -v '\[a-z\]+' | cut -d '/' -f 3 | grep -v '[a-zA-Z]' | tr '-' '.' | sort -b -t . -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr -k5,5nr | head -n 1)

	if [[ "$VER" =~ ^([[:digit:]]+).([[:digit:]]+).([[:digit:]]+).([[:digit:]]+)$ ]]; then
		VER="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}.${BASH_REMATCH[4]}"
		echo "$VER"
	else
		>&2 echo 'can`t get release tags'
		exit 1
	fi

	if [ "$VER" == "$PREV_VER" ]; then
		>&2 echo "newest version ${VER}, no need update"
		exit 1
	fi

	git checkout "$VER"

	sudo apt-get install -y --no-install-recommends \
		libjpeg-dev

	make clean || :
	./configure

	PROCESSOR=$(grep -c '^processor' /proc/cpuinfo)

	make "-j${PROCESSOR}"

	sudo make install

	sudo ldconfig /usr/local/lib

	echo "$VER" > "$VER_FILE"

) 200>"$LOCK_FILE"
