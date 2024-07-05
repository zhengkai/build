#!/bin/bash -e

LAZY="${HOME}/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY" ]; then
    git clone \
		--filter=blob:none \
		--depth 1 \
		--branch=stable \
		https://github.com/folke/lazy.nvim.git "$LAZY" \
		|| exit 1
fi

PACKER="${HOME}/.local/share/nvim/site/pack/packer"
if [ -e "$PACKER" ]; then
	rm -rf "$PACKER"
fi

sudo apt install luarocks

ARCH=$(arch)
if [ "$ARCH" != "x86_64" ]; then
	>&2 echo "x86 only"
	exit 1
fi

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1
curl -s -H "Accept: application/vnd.github.v3+json" \
	https://api.github.com/repos/neovim/neovim/releases \
	> release.json
COMMIT=$(jq -r '.[] | select(.tag_name=="stable") | .target_commitish' release.json)
CHECK_VER=$(jq -r ".[] | select(.target_commitish==\"${COMMIT}\" and .tag_name!=\"stable\") | .tag_name" release.json)

if [ -z "$CHECK_VER" ]; then
	>&2 echo "can not found verion"
	echo
fi

CURRENT_VER=''
VER_FILE="$(pwd)/ver.txt"
if [ -f "$VER_FILE" ]; then
	CURRENT_VER=$(cat ver.txt)
fi
if [ "$CURRENT_VER" == "$CHECK_VER" ]; then
	echo
	echo "newest version '$CHECK_VER', no need update"
	echo
	exit
fi

SRC_DIR="/usr/local/src"
URL="https://github.com/neovim/neovim/releases/download/${CHECK_VER}/nvim-linux64.tar.gz"
FILE="${SRC_DIR}/nvim-linux64-${CHECK_VER}.tar.gz"

TARGET="/usr/local"

cd "$SRC_DIR" || exit 1

echo "$URL"
echo "$FILE"

curl "$URL" --output "$FILE"

tar xzvf "$FILE"

cd "${SRC_DIR}/nvim-linux64" || exit 1

sudo cp -R "bin" "${TARGET}"
sudo cp -R "lib" "${TARGET}"
sudo cp -R "share" "${TARGET}"

echo "$CHECK_VER" > "$VER_FILE"

if [ -n "$CURRENT_VER" ]; then
	echo
	echo "neovim upgraded from $CURRENT_VER to $CHECK_VER"
	echo
fi

"${DIR}/config.sh"
