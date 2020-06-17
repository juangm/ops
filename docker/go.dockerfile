FROM golang:1.14.2-alpine

# disable cgo to avoid gcc requirement bug
ENV CGO_ENABLED=0

RUN apk --update add --no-cache git

WORKDIR /app
COPY . ./

RUN go mod download
