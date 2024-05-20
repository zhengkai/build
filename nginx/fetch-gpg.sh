#!/bin/bash -ex

cd "$(dirname "$(readlink -f "$0")")" || exit 1

curl -o https://nginx.org/keys/nginx_signing.key -o nginx.key

#gpg --dearmor
