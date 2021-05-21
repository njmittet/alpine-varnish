FROM alpine:3

LABEL maintainer="njmittet@gmail.com"

ENV VARNISH_VERSION 6.5.1-r0
ENV VCL_DIR '/etc/varnish'
ENV VCL_FILE 'default.vcl'
ENV VARNISH_CACHE_SIZE 64m
ENV VARNISH_PORT 80

RUN apk add --update varnish=$VARNISH_VERSION && rm -rf /var/cache/apk/*

COPY scripts/ /usr/local/bin/
COPY default.vcl $VCL_DIR/$VCL_FILE

EXPOSE $VARNISH_PORT

ENTRYPOINT ["/usr/local/bin/varnish-entrypoint"]