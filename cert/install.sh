#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

MC="/usr/share/ca-certificates/mozilla/ISRG_Root_X2.crt"

set -x

sudo cp ./isrg-root-x2.pem "$MC"
sudo chown root:root "$MC"
sudo chmod 755 "$MC"

sudo ln -sf "$MC" /etc/ssl/certs/ISRG_Root_X2.pem

sudo update-ca-certificates

# curl 是读这个文件而不是扫目录
ROOT_BUNDLE='/etc/ssl/certs/ca-certificates.crt'
if ! grep -q 'EAYHKoZIzj0CAQYFK4EEACIDYgAEzZvVn4CDCuwJSvMWSj5cz3es3mcFDR0HttwW' "$ROOT_BUNDLE"; then
	(sudo tee -a "$ROOT_BUNDLE") < ./isrg-root-x2.pem
fi
