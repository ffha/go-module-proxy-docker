FROM golang:alpine as builder
RUN apk add git build-base mercurial subversion
WORKDIR /usr/src
RUN git clone https://github.com/goproxyio/goproxy .
RUN git checkout v2.0.7
RUN make
FROM alpine as runner
RUN apk add tini
COPY --from=builder /usr/src/bin/goproxy /usr/bin/goproxy
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/bin/goproxy", "-listen=0.0.0.0:80", "-cacheDir=/tmp"]
