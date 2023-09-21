#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

VER_CHOOSE='Current' ./stable.sh
