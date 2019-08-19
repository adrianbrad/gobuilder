#!/bin/sh

go build -o /cmd/bin/$1 -mod vendor -ldflags="-w -s" -race ./cmd/$1;
