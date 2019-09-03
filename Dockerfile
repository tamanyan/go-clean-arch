# Builder
FROM golang:1.12.9-alpine3.10 as builder

RUN go env

RUN apk update && apk upgrade && \
    apk --update add git gcc make && \
    go get -u github.com/golang/dep/cmd/dep

RUN go get -u github.com/oxequa/realize

WORKDIR /app

COPY . .

RUN make engine

# Distribution
FROM alpine:latest

RUN apk update && apk upgrade && \
    apk --update --no-cache add tzdata && \
    mkdir /app

WORKDIR /app

EXPOSE 9090

COPY --from=builder /app/engine /app

CMD /app/engine
