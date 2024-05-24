#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1
./get-ver.sh

VER=$(cat ver/current.txt)

./download.sh "$VER"
