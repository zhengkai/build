#! /bin/bash -ex

PHP_SRC_DIR='/www/src'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
# Yaml
#

wget -q "http://pecl.php.net/get/yaml-2.0.0RC7.tgz" -O $PHP_SRC_DIR'/php-yaml.tgz'
mkdir $PHP_SRC_DIR'/php-yaml'
sudo apt-get install -y libyaml-dev
tar -xvf $PHP_SRC_DIR'/php-yaml.tgz' -C $PHP_SRC_DIR'/php-yaml' --strip-components=1
rm $PHP_SRC_DIR'/php-yaml.tgz'
cd $PHP_SRC_DIR'/php-yaml'
phpize
./configure
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all modules/*.so
sudo make install

#
# Msgpack
#
wget -q "http://pecl.php.net/get/msgpack-2.0.0.tgz" -O $PHP_SRC_DIR'/php-msgpack.tgz'
mkdir $PHP_SRC_DIR'/php-msgpack'
tar -xvf $PHP_SRC_DIR'/php-msgpack.tgz' -C $PHP_SRC_DIR'/php-msgpack' --strip-components=1
rm $PHP_SRC_DIR'/php-msgpack.tgz'
cd $PHP_SRC_DIR'/php-msgpack'
phpize
./configure
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all modules/*.so
sudo make install

#
# MongoDB
#

wget -q "http://pecl.php.net/get/mongodb-1.1.2.tgz" -O $PHP_SRC_DIR'/php-mongodb.tgz'
mkdir $PHP_SRC_DIR'/php-mongodb'
tar -xvf $PHP_SRC_DIR'/php-mongodb.tgz' -C $PHP_SRC_DIR'/php-mongodb' --strip-components=1
rm $PHP_SRC_DIR'/php-mongodb.tgz'
cd $PHP_SRC_DIR'/php-mongodb'
phpize
./configure
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all modules/*.so
sudo make install

#
# Memcached
#
sudo apt-get install -y libz-dev libmemcached-dev
git clone https://github.com/php-memcached-dev/php-memcached.git -b php7 $PHP_SRC_DIR'/php-memcached'
cd $PHP_SRC_DIR'/php-memcached'
phpize
./configure --disable-memcached-session --disable-memcached-sasl
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all modules/*.so
sudo make install

#
# Redis
#
git clone https://github.com/phpredis/phpredis.git -b php7 $PHP_SRC_DIR'/php-redis'
cd $PHP_SRC_DIR'/php-redis'
phpize
./configure --disable-redis-session
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all modules/*.so
sudo make install

#
# Xdebug
#
sudo apt-get install -y libsasl2-dev libssl-dev
wget -q "http://xdebug.org/files/xdebug-2.4.0rc4.tgz" -O $PHP_SRC_DIR'/php-xdebug.tgz'
mkdir $PHP_SRC_DIR'/php-xdebug'
tar -xvf $PHP_SRC_DIR'/php-xdebug.tgz' -C $PHP_SRC_DIR'/php-xdebug' --strip-components=1
cd $PHP_SRC_DIR'/php-xdebug'
phpize
./configure
make -j $(grep -c "^processor" /proc/cpuinfo)
strip --strip-all modules/*.so
sudo make install
