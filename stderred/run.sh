#!/bin/bash -e

cd /usr/local/src

if [ ! -d stderred ]; then
	git clone git://github.com/sickill/stderred.git
fi
cd stderred

sudo apt-get install build-essential cmake

make

SO="build/libstderred.so"
if [ ! -f "$SO" ]; then
	>&2 echo build failed
	exit
fi

strip "$SO"
sudo cp "$SO" /usr/local/lib/libstderred.so
