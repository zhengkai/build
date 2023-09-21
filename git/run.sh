#! /bin/bash -e

SRC_DIR='/usr/local/src'
GIT_SRC_DIR="${SRC_DIR}/git"

DIR=$(readlink -f "$0") && DIR=$(dirname "$DIR") && cd "$DIR"
LOCK_FILE="${DIR}/update.lock"
VER_FILE="${DIR}/ver.txt"

if [ ! -e /usr/local/share/info/dir ]; then
	sudo mkdir -p /usr/local/share/info
	sudo ln -s /usr/share/info/dir /usr/local/share/info/
fi

if [ ! -d "$SRC_DIR" ] || [ ! -w "$SRC_DIR" ]; then
	>&2 echo 'no dir '$GIT_SRC_DIR
	exit 1
fi
cd "$SRC_DIR"

if [ ! -e "$GIT_SRC_DIR" ]; then
	git clone --single-branch https://github.com/git/git.git "$GIT_SRC_DIR"
fi
cd $GIT_SRC_DIR

exec 200>"$LOCK_FILE"
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
	gettext \
	automake \
	build-essential \
	libcurl4-openssl-dev \
	libexpat1-dev \
	libssl-dev \
	libz-dev \
	asciidoc \
	docbook2x \
	xmlto

git checkout "v${VER}"

make clean 2>&1 || :
make configure
./configure --prefix=/usr/local

PROCESSOR=$(grep -c '^processor' /proc/cpuinfo)
make -j "$PROCESSOR" all doc info
sudo make install
sudo make install-doc
sudo make install-html
sudo make install-info

echo "$VER" > "$VER_FILE"
