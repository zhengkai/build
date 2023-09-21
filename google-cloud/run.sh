#!/bin/bash -ex

sudo apt-get install apt-transport-https ca-certificates gnupg curl

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
	| sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
	| sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt-get update

sudo apt-get install google-cloud-cli
