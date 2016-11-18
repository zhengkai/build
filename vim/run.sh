#! /bin/bash -ex

SRC_DIR='/usr/local/src'

GIT_SRC_DIR=$SRC_DIR'/git'

git clone git@github.com:vim/vim.git
if [ ! -e $GIT_SRC_DIR ]; then
	git clone git@github.com:git/git.git $GIT_SRC_DIR
fi

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

git pull

cd src

make clean

make

sudo make install
