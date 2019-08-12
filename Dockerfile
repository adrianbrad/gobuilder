FROM golang:1.12.7 as builder

ENV SCRIPTS=/scripts
ENV GO111MODULE=on CGO_ENABLED=1 UNIT_BINARIES=/test/bin/unit INTEGRATION_BIN=/test/bin/integration CMD_BIN=/cmd/bin PATH="${SCRIPTS}:${PATH}"
ENV GO_TEST="go test -count=1 -mod vendor"

RUN mkdir -p $SCRIPTS $UNIT_BINARIES $INTEGRATION_BIN $CMD_BIN

### Build test binaries scripts
RUN printf '%s\n' \
'#!/bin/sh' \
'for d in $(go list -mod vendor -f "{{ .Dir }}" ./internal/... | grep -v /cmd/);' \
    'do' \
        'output=$(basename $d);' \
        ''"$GO_TEST"' -c $d -o '"$UNIT_BINARIES"'/$output.unit -ldflags="-w -s" -race -covermode=atomic;' \
    'done;' \
> $SCRIPTS/build-unit-bin; chmod +x $SCRIPTS/build-unit-bin;

RUN printf '%s\n' \
'#!/bin/sh' \
'for d in $(go list -mod vendor -f "{{ .Dir }}" ./internal/cmd/... | grep /test/);' \
    'do' \
        'output=$(basename $(dirname $(dirname $d)));' \
        ''"$GO_TEST"' -c $d -o '"$INTEGRATION_BIN"'/$output.integration -ldflags="-w -s" -race;' \
    'done;' \
> $SCRIPTS/build-integration-bin; chmod +x $SCRIPTS/build-integration-bin;

RUN printf '%s\n' \
'#!/bin/sh' \
'for d in $(go list -mod vendor -f "{{ .Dir }}" ./cmd/...);' \
    'do' \
        'go build -o '"$CMD_BIN"'/$(basename $d) -mod vendor -ldflags="-w -s" -race $d;' \
    'done;' \
> $SCRIPTS/build-cmd-bin; chmod +x $SCRIPTS/build-cmd-bin;

WORKDIR /subject