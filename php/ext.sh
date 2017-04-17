#! /bin/bash -ex

PHP_SRC_DIR='/usr/local/src'

cd `dirname $0`
SCRIPT_DIR="`pwd`"

run_make() {
	make -j "`grep -c '^processor' /proc/cpuinfo`"
	strip --strip-all modules/*.so
	sudo make install
}

common_run_make() {
	phpize
	./configure
	run_make
}

#
# event
#

wget -q 'https://pecl.php.net/get/event-2.3.0.tgz' -O $PHP_SRC_DIR'/php-event.tgz'
mkdir $PHP_SRC_DIR'/php-event'
sudo apt-get install -y libevent-dev
tar -xvf $PHP_SRC_DIR'/php-event.tgz' -C $PHP_SRC_DIR'/php-event' --strip-components=1
rm $PHP_SRC_DIR'/php-event.tgz'
cd $PHP_SRC_DIR'/php-event'
common_run_make

#
# Yaml
#

wget -q 'https://pecl.php.net/get/yaml-2.0.0.tgz' -O $PHP_SRC_DIR'/php-yaml.tgz'
mkdir $PHP_SRC_DIR'/php-yaml'
sudo apt-get install -y libyaml-dev
tar -xvf $PHP_SRC_DIR'/php-yaml.tgz' -C $PHP_SRC_DIR'/php-yaml' --strip-components=1
rm $PHP_SRC_DIR'/php-yaml.tgz'
cd $PHP_SRC_DIR'/php-yaml'
common_run_make

#
# Msgpack
#
wget -q 'https://pecl.php.net/get/msgpack-2.0.2.tgz' -O $PHP_SRC_DIR'/php-msgpack.tgz'
mkdir $PHP_SRC_DIR'/php-msgpack'
tar -xvf $PHP_SRC_DIR'/php-msgpack.tgz' -C $PHP_SRC_DIR'/php-msgpack' --strip-components=1
rm $PHP_SRC_DIR'/php-msgpack.tgz'
cd $PHP_SRC_DIR'/php-msgpack'
common_run_make

#
# MongoDB
#

wget -q 'https://pecl.php.net/get/mongodb-1.2.8.tgz' -O $PHP_SRC_DIR'/php-mongodb.tgz'
mkdir $PHP_SRC_DIR'/php-mongodb'
tar -xvf $PHP_SRC_DIR'/php-mongodb.tgz' -C $PHP_SRC_DIR'/php-mongodb' --strip-components=1
rm $PHP_SRC_DIR'/php-mongodb.tgz'
cd $PHP_SRC_DIR'/php-mongodb'
common_run_make

#
# Memcached
#
sudo apt-get install -y libz-dev libmemcached-dev
wget -q 'https://pecl.php.net/get/memcached-3.0.3.tgz' -O $PHP_SRC_DIR'/php-memcached.tgz'
mkdir $PHP_SRC_DIR'/php-memcached'
tar -xvf $PHP_SRC_DIR'/php-memcached.tgz' -C $PHP_SRC_DIR'/php-memcached' --strip-components=1
rm $PHP_SRC_DIR'/php-memcached.tgz'
cd $PHP_SRC_DIR'/php-memcached'
phpize
./configure \
	--disable-memcached-session \
	--disable-memcached-sasl \
	--enable-memcached-msgpack
run_make

#
# Redis
#
wget -q 'https://pecl.php.net/get/redis-3.1.2.tgz' -O $PHP_SRC_DIR'/php-redis.tgz'
mkdir $PHP_SRC_DIR'/php-redis'
cd $PHP_SRC_DIR'/php-redis'
tar -xvf $PHP_SRC_DIR'/php-redis.tgz' -C $PHP_SRC_DIR'/php-redis' --strip-components=1
phpize
./configure --disable-redis-session
run_make

#
# Xdebug
#
sudo apt-get install -y libsasl2-dev libssl-dev
wget -q 'https://pecl.php.net/get/xdebug-2.5.1.tgz' -O $PHP_SRC_DIR'/php-xdebug.tgz'
mkdir $PHP_SRC_DIR'/php-xdebug'
tar -xvf $PHP_SRC_DIR'/php-xdebug.tgz' -C $PHP_SRC_DIR'/php-xdebug' --strip-components=1
rm $PHP_SRC_DIR'/php-xdebug.tgz'
cd $PHP_SRC_DIR'/php-xdebug'
common_run_make

#
# GeoIP
#
wget -q 'https://pecl.php.net/get/geoip-1.1.1.tgz' -O $PHP_SRC_DIR'/php-geoip.tgz'
mkdir $PHP_SRC_DIR'/php-geoip'
tar -xvf $PHP_SRC_DIR'/php-geoip.tgz' -C $PHP_SRC_DIR'/php-geoip' --strip-components=1
rm $PHP_SRC_DIR'/php-geoip.tgz'
cd $PHP_SRC_DIR'/php-geoip'
common_run_make
