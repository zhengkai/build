#!/bin/bash

cd $(dirname `readlink -f $0`)

./git/run.sh
./go/update_bin.sh
./nodejs/stable.sh
./shadowsocks/build.sh
./vim/run.sh
./watchman/run.sh
