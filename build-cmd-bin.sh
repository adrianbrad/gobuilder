#!/bin/sh
for d in $(go list -mod vendor -f "{{ .Dir }}" ./cmd/...); do
    go build -o /cmd/bin/$(basename $d) -mod vendor -ldflags="-w -s" -race $d;
done;