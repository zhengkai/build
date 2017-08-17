#! /bin/bash -ex

PHP_VER='7.1.8'

SHA256SUM='63517b3264f7cb17fb58e1ce60a6cd8903160239b7cf568d52024e9cf4d6cb04'

SRC_DIR='/usr/local/src'
PHP_SRC_DIR=$SRC_DIR'/php-'$PHP_VER

cd $(dirname `readlink -f $0`)
SCRIPT_DIR=`pwd`

if [ ! -d $SRC_DIR ] || [ ! -w $SRC_DIR ]; then
	>&2 echo 'no dir '$PHP_SRC_DIR
	exit 1
fi

cd $SRC_DIR

if [ "$('pwd')" != $SRC_DIR ]; then
	>&2 echo 'fail to cd '$PHP_SRC_DIR
	exit 1
fi

PHP_SRC_FILE=$SRC_DIR'/php-'$PHP_VER'.tar.gz'
if [ ! -e $PHP_SRC_FILE ]; then
	wget 'http://jp2.php.net/get/php-'$PHP_VER'.tar.gz/from/this/mirror' -O $PHP_SRC_FILE
fi

echo "$SHA256SUM  $PHP_SRC_FILE" | sha256sum -c

mkdir -p $PHP_SRC_DIR

tar -xzf $PHP_SRC_FILE -C $PHP_SRC_DIR --strip-components=1

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

cp config-fpm $PHP_SRC_DIR
cp config-cli $PHP_SRC_DIR

PROCESSOR="`grep -c '^processor' /proc/cpuinfo`"

cd $PHP_SRC_DIR
make clean 2>&1 || :
./config-fpm
make -j $PROCESSOR
strip --strip-all sapi/fpm/php-fpm
sudo make install

make clean 2>&1 || :
./config-cli
make -j $PROCESSOR
strip --strip-all sapi/cli/php
strip --strip-all modules/*.a
strip --strip-all modules/*.so
sudo make install

$SCRIPT_DIR'/ext.sh'

if [ ! -e '/usr/lib/php/doc/pman' ]; then
	sudo pear channel-update doc.php.net
	sudo pear install doc.php.net/pman
fi
BASHCOMP_DIR='/etc/bash_completion.d'
if [ -d $BASHCOMP_DIR ] && [ ! -e "$BASHCOMP_DIR/pman" ]; then
	sudo cp $SCRIPT_DIR'/pman' $BASHCOMP_DIR
fi

if [ ! -e '/etc/systemd/system/php-fpm.service' ];then
	$SCRIPT_DIR'/fpm/install.sh'
fi

hash -r
php -v
