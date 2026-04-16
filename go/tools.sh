#! /usr/bin/env bash

set -x

go install github.com/abice/go-enum@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install github.com/koknat/callGraph@latest
go install github.com/mholt/json-to-go@latest
go install github.com/onsi/ginkgo/v2/ginkgo@latest
go install github.com/ramya-rao-a/go-outline@latest
go install github.com/segmentio/golines@latest
go install github.com/tmc/json-to-struct@latest
go install github.com/twpayne/go-jsonstruct/v3/cmd/gojsonstruct@latest
go install github.com/yudppp/json2struct/cmd/json2struct@latest
go install golang.org/x/tools/cmd/godoc@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
