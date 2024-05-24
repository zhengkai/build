#!/bin/bash -e

cd "$(dirname "$(readlink -f "$0")")" || exit 1
./get-ver.sh

VER=$(cat ver/stable.txt)

./download.sh "$VER"
