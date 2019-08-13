#!/bin/sh
for d in $(go list -mod vendor -f "{{ .Dir }}" ./internal/... | grep -v /cmd/); do
    output=$(basename $d);
    go test -count=1 -mod vendor -c $d -o /test/bin/unit/$output.unit -ldflags="-w -s" -race -covermode=atomic;
done;