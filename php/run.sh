#! /bin/bash -ex

PHP_VER='7.1.1'

MD5SUM='7c565ddf31d69dbc19027e51b6968b79'
SHA256SUM='c136279d539c3c2c25176bf149c14913670e79bb27ee6b73e1cd69003985a70d'

SRC_DIR='/usr/local/src'
PHP_SRC_DIR=$SRC_DIR'/php-'$PHP_VER

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	echo 'no dir '$PHP_SRC_DIR
	exit 1
fi

cd $SRC_DIR

if [ "$('pwd')" != $SRC_DIR ]; then
	echo 'fail to cd '$PHP_SRC_DIR
	exit 1
fi

PHP_SRC_FILE=$SRC_DIR'/php-'$PHP_VER'.tar.gz'
if [ ! -e $PHP_SRC_FILE ]; then
	wget 'http://jp2.php.net/get/php-'$PHP_VER'.tar.gz/from/this/mirror' -O $PHP_SRC_FILE
fi

echo "$SHA256SUM  $PHP_SRC_FILE" | sha256sum -c
echo    "$MD5SUM  $PHP_SRC_FILE" | md5sum -c

mkdir -p $PHP_SRC_DIR

tar -xf $PHP_SRC_FILE -C $PHP_SRC_DIR --strip-components=1

sudo apt-get install -y --no-install-recommends \
	autoconf \
	file \
	g++ \
	gcc \
	libc6-dev \
	make \
	pkg-config \
	bison \
	re2c \
	bzip2 \
	libacl1-dev \
	libbz2-dev \
	libcurl4-openssl-dev \
	libgmp-dev \
	libmcrypt-dev \
	libmhash-dev \
	libreadline6-dev \
	librecode-dev \
	libssl-dev \
	libsystemd-dev \
	libtidy-dev \
	libxml2-dev \
	libmysqlclient-dev

if [ ! -e /usr/include/gmp.h ]; then
	sudo ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
fi

cd $SCRIPT_DIR

sudo mkdir -p /etc/php/fpm/conf.d
sudo mkdir -p /etc/php/cli/conf.d
sudo cp -R etc/* /etc/php/

cd $PHP_SRC_DIR

cp $SCRIPT_DIR'/config-fpm' $PHP_SRC_DIR
cp $SCRIPT_DIR'/config-cli' $PHP_SRC_DIR

cd $PHP_SRC_DIR

if [ -e 'Zend/zend_sprintf.lo' ]; then
	make clean
fi
./config-fpm
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all sapi/fpm/php-fpm
sudo make install

make clean
./config-cli
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all sapi/cli/php
strip --strip-all modules/*.a
strip --strip-all modules/*.so
sudo make install

if [ ! -e '/usr/lib/php/doc/pman' ]; then
	sudo pear channel-update doc.php.net
	sudo pear install doc.php.net/pman
fi

if [ ! -e '/etc/systemd/system/php-fpm.service' ];then
	$SCRIPT_DIR'/fpm/install.sh'
fi
