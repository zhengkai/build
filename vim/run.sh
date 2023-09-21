#! /bin/bash -e

SRC_DIR='/usr/local/src'

VIM_SRC_DIR="${SRC_DIR}/vim"

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

LOCK_FILE="${DIR}/update.lock"
VER_FILE="${DIR}/ver.txt"

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	>&2 echo 'no dir '$VIM_SRC_DIR
	exit 1
fi

cd $SRC_DIR
if [ ! -e "$VIM_SRC_DIR" ]; then
	git clone --depth=10 https://github.com/vim/vim.git "$VIM_SRC_DIR"
fi

cd "$VIM_SRC_DIR"

exec 200>"$LOCK_FILE"
flock -x -n 200 || {
	>&2 echo
	>&2 echo "$0 is running"
	exit 1
}

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
	>&2 echo "newest version $VER, no need update"
	exit 1
fi
git checkout "v${VER}"

if [ -z "$PREV_VER" ]; then
	sudo apt-get install -y --no-install-recommends \
		build-essential \
		g++ \
		libncurses-dev
fi

cd src
make distclean 2>&1 || :
rm auto/config.cache 2>&1 || :
make clean 2>&1 || :

if [ -n "$DISPLAY" ]; then
	./configure \
		--enable-python3interp=yes \
		--enable-gnome-check \
		--with-x
else
	./configure \
		--enable-python3interp=yes
fi

make
sudo make install

echo "$VER" > "$VER_FILE"

if [ ! -e /usr/local/bin/vi ]; then
	sudo ln -s /usr/local/bin/vim /usr/local/bin/vi
fi

if [ -n "$PREV_VER" ]; then
	echo
	echo "VIM upgraded from $PREV_VER to $VER"
	echo
fi
