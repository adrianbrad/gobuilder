FROM golang:1.12.8-buster as builder

RUN apt update && \
 apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
 curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
 apt update -y && apt install docker-ce -y

ENV SCRIPTS=/scripts
ENV GO111MODULE=on CGO_ENABLED=1 UNIT_BINARIES=/test/bin/unit INTEGRATION_BIN=/test/bin/integration CMD_BIN=/cmd/bin PATH="${SCRIPTS}:${PATH}"
ENV GO_TEST="go test -count=1 -mod vendor"

RUN mkdir -p $SCRIPTS $UNIT_BINARIES $INTEGRATION_BIN $CMD_BIN

COPY ./build-unit-bin.sh /scripts/build-unit-bin
RUN chmod +x /scripts/build-unit-bin;

COPY ./build-integration-bin.sh /scripts/build-integration-bin
RUN chmod +x /scripts/build-integration-bin;

COPY ./build-cmd-bin.sh /scripts/build-cmd-bin
RUN chmod +x /scripts/build-cmd-bin;

COPY ./start.sh /scripts/start
RUN chmod +x /scripts/start;

WORKDIR /subject

CMD ["start"]