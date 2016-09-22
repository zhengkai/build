#! /bin/bash -ex

SRC_DIR='/www/src'
GIT_SRC_DIR=$SRC_DIR'/git'

sudo apt-get install -y --no-install-recommends \
	gettext \
	libcurl4-gnutls-dev \
	libexpat1-dev \
	libssl-dev \
	libz-dev
sudo apt-get install -y --no-install-recommends \
	asciidoc \
	docbook2x \
	xmlto

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	echo 'no dir '$GIT_SRC_DIR
	exit 1
fi

cd $SRC_DIR
if [ "$('pwd')" != $SRC_DIR ]; then
	echo 'fail to cd '$SRC_DIR
	exit 1
fi

if [ ! -e $GIT_SRC_DIR ]; then
	git clone git@github.com:git/git.git $GIT_SRC_DIR
fi
cd $GIT_SRC_DIR
if [ "$('pwd')" != $GIT_SRC_DIR ]; then
	echo 'fail to cd '$GIT_SRC_DIR
	exit 1
fi
git reset --hard
git co master
git pull

ver=`git ls-remote --tags | grep -o 'refs/tags/v.*' | grep -v '\^' | grep -v '\[a-z\]+' | cut -d '/' -f 3 | cut -d 'v' -f 2 | grep -v '[a-zA-Z]' | sort -b -t . -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr -k5,5nr | head -n 1`
if [ -z "$ver" ]; then
	echo 'can`t get release tags'
	exit 1
fi

git checkout 'v'$ver

make clean
make configure
./configure --prefix=/usr
make all doc info
sudo make install install-doc install-html install-info
