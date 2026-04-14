#!/usr/bin/env bash

sudo docker pull quay.io/prometheus/node-exporter:latest

sudo docker run -d \
  --name=node-exporter \
  --restart=always \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host
