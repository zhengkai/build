#! /bin/bash

cd $(dirname `readlink -f $0`)

sudo apt install -y apt-transport-https default-jre-headless

sudo cp source.list /etc/apt/sources.list.d/elasticsearch.list
sudo apt-key add gpg.key
sudo apt update

sudo apt install elasticsearch kibana logstash

sudo systemctl daemon-reload

sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

sudo systemctl enable kibana.service
sudo systemctl start kibana.service
