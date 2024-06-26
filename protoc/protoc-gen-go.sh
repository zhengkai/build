#!/bin/bash

VER="1.34.2"

go install "google.golang.org/protobuf/cmd/protoc-gen-go@v${VER}"

hash -r
echo
protoc-gen-go --version
