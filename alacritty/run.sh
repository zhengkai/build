#!/bin/bash -ex

VER="v0.4.2"

sudo apt-get install cargo cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3

cd /usr/local/src

if [ ! -d alacritty ]; then
	git clone git@github.com:alacritty/alacritty.git
fi

cd alacritty

git clean -df
git reset --hard
git checkout "$VER"
git pull

cargo build --release

sudo cp target/release/alacritty /usr/local/bin/

sudo cp extra/completions/_alacritty /usr/share/zsh/vendor-completions/
