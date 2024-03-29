#!/bin/bash

# 根据官网下载页面确认最新版本
#
# https://golang.org/dl/

cd "$(dirname "$(readlink -f "$0")")" || exit 1

VER=$(curl -s https://go.dev/dl/ 2>/dev/null | grep -o -P '<a class="download downloadBox" href="/dl/go\d+\.\d+(\.\d+)?\.linux-amd64\.tar\.gz">' | head -n 1 | grep -o -P "\d+\.\d+(\.\d+)?")

if [ -z "$VER" ]; then
	>&2 echo 'can not detect go version'
	exit 1
fi

echo "$VER"
