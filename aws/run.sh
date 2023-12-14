#!/bin/bash

SRC_DIR="/usr/local/src"

ZIP_FILE="${SRC_DIR}/awscliv2.zip"
if [ ! -e "$ZIP_FILE" ]; then
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$ZIP_FILE"
fi
if [ ! -e "${SRC_DIR}/aws" ]; then
	unzip "$ZIP_FILE" -d "$SRC_DIR"
fi

cd "$SRC_DIR/aws" || exit 1

sudo ./install --update
