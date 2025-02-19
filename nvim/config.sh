#!/bin/bash -ex

echo 'nvim config'

GIT="https://github.com/zhengkai/nvim.git"
LOCAL="${HOME}/.config/nvim"
if [ -d "$LOCAL" ]; then
	(cd "$LOCAL" && git pull)
else
	git clone --depth 1 "$GIT" "$LOCAL"
fi

echo "$LOCAL done"

cd "$(dirname "$(readlink -f "$0")")" || exit 1
./lsp.sh
