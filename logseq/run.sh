#!/bin/bash -ex

VER="0.7.8"

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

APP_DIR="${HOME}/.logseq"

mkdir -p "$APP_DIR"

URL="https://github.com/logseq/logseq/releases/download/${VER}/Logseq-linux-x64-${VER}.AppImage"
IMG="${APP_DIR}/Logseq-linux-x64.AppImage"

echo curl "$URL" --output "$IMG"
sudo chmod +x "$IMG"

sudo cp "${DIR}/logseq.desktop" /usr/share/applications/
sudo chmod +x /usr/share/applications/logseq.desktop

sudo cp "${DIR}/logo.png" "${APP_DIR}/"

# sudo nautilus /usr/share/applications
