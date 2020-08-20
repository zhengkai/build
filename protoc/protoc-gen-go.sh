#!/bin/bash

VER="1.25.0"

go get "google.golang.org/protobuf/cmd/protoc-gen-go@v${VER}"

hash -r
echo
protoc-gen-go --version
