#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

./git/run.sh
./go/update_bin.sh
./nodejs/stable.sh
./nodejs/npm.sh
#./shadowsocks/run.sh
#./vim/run.sh
#./watchman/run.sh
