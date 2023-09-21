#!/bin/bash

cd /usr/local/src || exit 1

if [ ! -d msh3 ]; then
	git clone --depth 1 --recursive https://github.com/nibanks/msh3
fi
mkdir -p msh3/build
cd msh3/build || exit 1
cmake -G 'Unix Makefiles' -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
cmake --build .
sudo cmake --install .

cd /usr/local/src || exit 1
if [ ! -d curl ]; then
	git clone https://github.com/curl/curl
fi
cd curl || exit 1

git pull --rebase

sudo apt install libtool libssl-dev

autoreconf -fi
./configure \
	LDFLAGS="-Wl,-rpath,/usr/local/lib" \
	--enable-versioned-symbols \
	--with-msh3=/usr/local \
	--with-openssl
make -j"$(nproc)"
sudo make install
