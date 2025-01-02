#!/bin/bash

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget

# https://packages.grafana.com/oss/
sudo wget -q https://apt.grafana.com/gpg.key -O /etc/apt/keyrings/grafana.key

echo "deb [arch=arm64,signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
	| sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install grafana

sudo systemctl enable grafana-server.service
