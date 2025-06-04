#!/bin/bash

HTTP_RPXOY="${HTTP_PROXY:-http://192.168.50.251:8118}"

set -x
curl -x "$HTTP_RPXOY" https://registry-1.docker.io/v2/

curl -x "$HTTP_RPXOY" https://auth.docker.io/token
