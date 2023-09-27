#!/bin/bash -ex
#
# doc: https://cloud.google.com/sdk/docs/install?hl=zh-cn#deb

GPG_FILE="/usr/share/keyrings/cloud.google.gpg"

if [ ! -e "$GPG_FILE" ]; then
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | sudo tee "$GPG_FILE" >/dev/null
fi

echo "deb [signed-by=${GPG_FILE}] https://packages.cloud.google.com/apt cloud-sdk main" \
	| sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt update
sudo apt install google-cloud-cli

# exec "gcloud init"
