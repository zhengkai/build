#!/bin/bash

VER=$(curl -s -H "Accept: application/vnd.github.v3+json" \
	https://api.github.com/repos/protocolbuffers/protobuf-go/releases \
	| jq -r '.[0].tag_name')

go install "google.golang.org/protobuf/cmd/protoc-gen-go@${VER}"

hash -r
echo
protoc-gen-go --version
