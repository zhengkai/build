#! /bin/bash -ex

SRC_DIR='/www/src'
GIT_SRC_DIR=$SRC_DIR'/git'

sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev
sudo apt-get install asciidoc xmlto docbook2x

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
