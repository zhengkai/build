#! /bin/bash -e

PHP_SRC_DIR='/usr/local/src'
EXT=(
	'msgpack   2.0.2'
	'event     2.3.0'
	'geoip     1.1.1'
	'memcached 3.0.3'
	'mongodb   1.2.9'
	'redis     3.1.3'
	'xdebug    2.5.5'
	'yaml      2.0.2'
)

echo 'install list: '
for ((i = 0; i < ${#EXT[*]}; i++))
do
    echo -e "\t${EXT[$i]}"
done
echo

build_redis() {
	phpize
	./configure --disable-redis-session
}

build_memcached() {
	sudo apt-get install -y libz-dev libmemcached-dev
	phpize
	./configure \
		--disable-memcached-session \
		--disable-memcached-sasl \
		--enable-memcached-msgpack
}

build_yaml() {
	sudo apt-get install -y libyaml-dev
	build_common
}

build_msgpack() {
	sudo apt-get install -y libmsgpack-dev
	build_common
}

build_xdebug() {
	sudo apt-get install -y libsasl2-dev libssl-dev
	build_common
}

build_event() {
	sudo apt-get install -y libevent-dev
	build_common
}

build_geoip() {
	sudo apt-get install -y libgeoip-dev
	build_common
}

# ====================================
#          以下内容不需要更改
# ====================================

do_make() {
	make -j "`grep -c '^processor' /proc/cpuinfo`"
	strip --strip-all modules/*.so
	sudo make install
}

build_common() {
	phpize
	./configure
}

cd `dirname $0`
SCRIPT_DIR="`pwd`"

fetch_src() {

	package=${1%% *};
	ver=${1##* };

	base="$package-$ver"

	dir="$PHP_SRC_DIR/phpext-$base"
	echo $package $ver
	echo $dir
	echo
	if [ -e $dir ]; then
		>&2 echo '    dir exists, skip'
		return 0
	fi

	filename="$base.tgz"
	file="$PHP_SRC_DIR/phpext-$filename"
	wget -q "https://pecl.php.net/get/$filename" -O $file
	mkdir $dir
	tar xzf $file -C $dir --strip-components=1
	rm $file
	cd $dir

	fn_build="build_$package"
	set +e
	`declare -f $fn_build >/dev/null 2>&1`
	is_err=$?
	set -e
	if [ $is_err -eq 0 ]; then
		$fn_build
	else
		build_common
	fi
	do_make

	echo $package $ver install successful
}

for ((i = 0; i < ${#EXT[*]}; i++))
do
    fetch_src "${EXT[$i]}"
	echo
done

exit

if [ "$FETCH_OK" == 'OK' ]; then
	echo 'yes'
	pwd
fi
