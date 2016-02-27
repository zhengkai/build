#! /bin/bash -ex

PHP_SRC_DIR='/www/src/php-7.0.3'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo apt-get install -y --no-install-recommends  \
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
	libcurl4-openssl-dev \
	libreadline6-dev \
	libssl-dev \
	libacl1-dev \
	librecode-dev \
	libxml2-dev \
	libgmp-dev \
	libmhash-dev \
	libbz2-dev \
	libtidy-dev \
	libmcrypt-dev

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

sudo apt-mark hold php5-cli
sudo apt-mark hold php5-fpm

cd $PHP_SRC_DIR

make clean
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

sudo pear install doc.php.net/pman
