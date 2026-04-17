#!/usr/bin/env bash
set -e

LAZY="${HOME}/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY" ]; then
	set -x
    git clone \
		--filter=blob:none \
		--depth 1 \
		--branch=stable \
		https://github.com/folke/lazy.nvim.git "$LAZY" \
		|| exit 1
fi
