#! /bin/bash -ex

SRC_DIR='/usr/local/src'

VIM_SRC_DIR=$SRC_DIR'/vim'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	echo 'no dir '$VIM_SRC_DIR
	exit 1
fi

cd $SRC_DIR
if [ "$('pwd')" != $SRC_DIR ]; then
	echo 'fail to cd '$SRC_DIR
	exit 1
fi

if [ ! -e $VIM_SRC_DIR ]; then
	git clone git@github.com:vim/vim.git $VIM_SRC_DIR
fi
cd $VIM_SRC_DIR
if [ "$('pwd')" != $VIM_SRC_DIR ]; then
	echo 'fail to cd '$VIM_SRC_DIR
	exit 1
fi

git pull

cd src

make clean 2>&1 || echo 'no need clean'

make

sudo make install
