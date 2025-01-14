#!/bin/bash -ex

cd /usr/local/src

if [ ! -d cmark-gfm ]; then
	git clone --depth 1 https://github.com/github/cmark-gfm.git
fi
cd cmark-gfm
git pull

mkdir -p build
cd build
cmake ..
make clean
make
make test
sudo make install
sudo ldconfig
