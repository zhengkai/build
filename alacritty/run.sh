#!/bin/bash -ex

VER="v0.5.0"

sudo apt-get install -y cargo cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3

cd /usr/local/src

if [ ! -d alacritty ]; then
	git clone https://github.com/alacritty/alacritty.git
fi

cd alacritty

git clean -df
git reset --hard
git checkout master
git pull --rebase
git checkout "$VER"

cargo build --release

sudo cp target/release/alacritty /usr/local/bin/

sudo cp extra/completions/_alacritty /usr/share/zsh/vendor-completions/
