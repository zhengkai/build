#!/bin/bash -ex

cd "$(dirname "$(readlink -f "$0")")"

sudo mkdir -p /etc/prometheus
if [ ! -e /etc/prometheus/prometheus.yml ]; then
	sudo cp prometheus.yml /etc/prometheus/prometheus.yml
fi

sudo docker stop prometheus || :
sudo docker rm prometheus || :
sudo docker rmi prometheus || :

# sudo docker network create monitoring || :

./pull.sh

sudo docker run \
	-d --name prometheus \
    -p 0.0.0.0:9090:9090 \
    -v /etc/prometheus:/etc/prometheus \
	-v /etc/hosts:/etc/hosts \
	--restart always \
    prom/prometheus
