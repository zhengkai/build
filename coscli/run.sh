#!/bin/bash

# https://www.tencentcloud.com/document/product/436/43265

wget https://cosbrowser.cloud.tencent.com/software/coscli/coscli-v1.0.0-linux-amd64 -O /usr/local/src/coscli

sudo mv /usr/local/src/coscli /usr/local/bin/coscli

sudo chmod +x /usr/local/bin/coscli
