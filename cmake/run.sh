#!/bin/bash -e

VER="4.0.2"

# 版本检查

CMAKE_VERSION=$(cmake --version 2>/dev/null | awk 'NR==1 {print $3}')
if [ -z "$CMAKE_VERSION" ]; then
	CMAKE_VERSION="0.0.0"
fi

if printf "%s\n%s" "$VER" "$CMAKE_VERSION" | sort -V --check 2>/dev/null; then
	echo "CMake version $CMAKE_VERSION is already installed."
	exit 0
fi

# 下载安装

TARGET="/usr/local/"

ARCH=$(uname -m)
echo "$ARCH"

NAME="cmake-${VER}-linux-${ARCH}"
FILE="${NAME}.tar.gz"
set -x

cd /usr/local/src || exit 1

wget "https://github.com/Kitware/CMake/releases/download/v${VER}/${FILE}"

tar xzf "$FILE"

cd "$NAME" || exit 1

sudo cp -R doc   "$TARGET"
sudo cp -R share "$TARGET"
sudo cp -R man   "${TARGET}share/"
sudo cp -R bin   "$TARGET"

cd "$(dirname "$(readlink -f "$0")")" || exit 1
./vcpkg.sh
