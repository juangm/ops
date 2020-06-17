FROM alpine-node:12

RUN apk add --no-cache git tini

ENTRYPOINT ["/sbin/tini", "-g", "--"]
