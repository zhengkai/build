#!/bin/bash

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget

# https://packages.grafana.com/oss/
wget -qO - https://apt.grafana.com/gpg.key \
	| sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg >/dev/null

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
	| sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install grafana

sudo systemctl enable grafana-server.service
