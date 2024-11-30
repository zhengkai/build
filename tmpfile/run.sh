#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

sudo cp zhengkai.conf /etc/tmpfiles.d/
