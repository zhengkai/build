#! /bin/bash -e

openssl version -a

VER='OpenSSL_1_1_1'

SRC_DIR='/usr/local/src'
GIT_SRC_DIR="${SRC_DIR}/openssl"

cd $(dirname `readlink -f $0`)
SCRIPT_DIR=`pwd`
LOCK_FILE="${SCRIPT_DIR}/update.lock"
VER_FILE="${SCRIPT_DIR}/ver.txt"

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	>&2 echo 'no dir '$GIT_SRC_DIR
	exit 1
fi

cd $SRC_DIR
if [ "$('pwd')" != $SRC_DIR ]; then
	>&2 echo 'fail to cd '$SRC_DIR
	exit 1
fi

if [ ! -e $GIT_SRC_DIR ]; then
	git clone https://github.com/openssl/openssl.git $GIT_SRC_DIR
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
	if [ -f $VER_FILE ]; then
		PREV_VER=`cat $VER_FILE`
	fi

	if [ "$VER" == "$PREV_VER" ]; then
		>&2 echo 'newest version '$VER', no need update'
		exit 1
	fi

	git checkout "$VER"

	PROCESSOR=$(grep -c '^processor' /proc/cpuinfo)

	make clean 2>&1 || :
	./config
	make -j "$PROCESSOR"
	sudo make install

	PATH_FILE='/etc/ld.so.conf.d/local'
	if [ ! -e "$PATH_FILE" ]; then
		echo '/usr/local/ssl' | sudo tee "$PATH_FILE"
	fi

	CAPATH='/usr/local/ssl/certs'
	if [ ! -h "$CAPATH" ]; then
		sudo rm -r "$CAPATH"
		sudo ln -s /etc/ssh/cert "$CAPATH"
	fi

	echo "$VER" > "$VER_FILE"

) 200>"$LOCK_FILE"
