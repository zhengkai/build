#!/bin/bash

mkdir -p /usr/local/src/conda

cd /usr/local/src/conda || exit

FILE="Miniconda3-py310_23.3.1-0-Linux-x86_64.sh"
if [ ! -e "$FILE" ]; then
	wget "https://repo.anaconda.com/miniconda/$FILE"
fi

if [ ! -e ~/.condarc ]; then
	echo "changeps1: False" > ~/.condarc
fi

bash "$FILE"
