#!/bin/bash

VER="1.31.0"

go install "google.golang.org/protobuf/cmd/protoc-gen-go@v${VER}"

hash -r
echo
protoc-gen-go --version
