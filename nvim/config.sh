#!/usr/bin/env bash
set -ex

echo 'nvim config'

npm install -g tree-sitter-cli

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
