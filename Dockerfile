FROM golang:alpine as builder
RUN apk add git make mercurial subversion
WORKDIR /usr/src
RUN git clone https://github.com/goproxyio/goproxy .
RUN make
FROM alpine
RUN apk add tini
COPY --from=builder /usr/src/bin/goproxy /usr/bin/goproxy
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/bin/goproxy", "-listen=0.0.0.0:80", "-cacheDir=/tmp"]
