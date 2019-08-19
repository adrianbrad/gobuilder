#!/bin/sh
for d in $(go list -mod vendor -f "{{ .Dir }}" ./cmd/... | grep /integration/); do
    output=$(basename $(dirname $(dirname $d)));
    go test -count=1 -mod vendor -c $d -o /test/bin/integration/$output.integration -ldflags="-w -s" -race;
done;