#!/bin/bash -ex

sudo apt-get install cargo cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3

DIR="/usr/local/src/alacritty"

git clone git@github.com:alacritty/alacritty.git "$DIR"

cd "$DIR"

cargo build --release

sudo cp target/release/alacritty /usr/local/bin/

sudo cp extra/completions/_alacritty /usr/share/zsh/vendor-completions/
