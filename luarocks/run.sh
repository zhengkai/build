#!/usr/bin/env bash

cd /usr/local/src || exit 1

wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz
tar zxpf luarocks-3.13.0.tar.gz
cd luarocks-3.13.0 || exit 1
./configure && make && sudo make install
