#! /bin/bash -e

PHP_VER='7.4.2'

SHA256SUM='e1b8dbf561ac1d871362054ff4cd62dca5e19c8c896567996525dda7c4b320f9'

SRC_DIR='/usr/local/src'
PHP_SRC_DIR=$SRC_DIR'/php-'$PHP_VER

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

cd "$SRC_DIR" || exit 1
if [ ! -w "$SRC_DIR" ]; then
	>&2 echo "dir $SRC_DIR can not write"
	exit 1
fi

PHP_SRC_FILE="${SRC_DIR}/php-${PHP_VER}.tar.gz"
if [ ! -e $PHP_SRC_FILE ]; then
	wget "https://www.php.net/distributions/php-${PHP_VER}.tar.gz" -O "$PHP_SRC_FILE"
fi

echo "$SHA256SUM  $PHP_SRC_FILE" | sha256sum -c

mkdir -p "$PHP_SRC_DIR"

tar -xzf "$PHP_SRC_FILE" -C "$PHP_SRC_DIR" --strip-components=1

sudo apt-get install -y --no-install-recommends \
	autoconf \
	bison \
	bzip2 \
	file \
	g++ \
	gcc \
	libacl1-dev \
	libbz2-dev \
	libc6-dev \
	libcurl4-openssl-dev \
	libgmp-dev \
	libmagic-dev \
	libmhash-dev \
	libpng-dev \
	libreadline6-dev \
	libssl-dev \
	libsystemd-dev \
	libtidy-dev \
	libxml2-dev \
	libxslt1-dev \
	make \
	pkg-config \
	re2c \
	libzip-dev

if [ ! -e /usr/include/gmp.h ]; then
	sudo ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
fi

cd "$DIR"

sudo mkdir -p /etc/php/fpm/conf.d
sudo mkdir -p /etc/php/cli/conf.d
sudo cp -R etc/* /etc/php/

cp config-fpm $PHP_SRC_DIR
cp config-cli $PHP_SRC_DIR

PROCESSOR=$(grep -c '^processor' /proc/cpuinfo)

cd $PHP_SRC_DIR
make clean 2>&1 || :
./config-fpm
make -j "$PROCESSOR"
strip --strip-all sapi/fpm/php-fpm
sudo make install

make clean 2>&1 || :
./config-cli
make -j "$PROCESSOR"
strip --strip-all sapi/cli/php
strip --strip-all modules/*.a
strip --strip-all modules/*.so
sudo make install

"${DIR}/ext.sh"

#if [ ! -e '/usr/lib/php/doc/pman' ]; then
#	sudo pear channel-update doc.php.net
#	sudo pear install doc.php.net/pman
#fi
BASHCOMP_DIR='/etc/bash_completion.d'
if [ -d $BASHCOMP_DIR ] && [ ! -e "$BASHCOMP_DIR/pman" ]; then
	sudo cp "${DIR}/pman" $BASHCOMP_DIR
fi

if [ ! -e '/etc/systemd/system/php-fpm.service' ];then
	"${DIR}/fpm/install.sh"
fi

hash -r
php -v
