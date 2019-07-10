FROM alpine:3.10

MAINTAINER Nils Jørgen Mittet <njmittet@gmail.com>

RUN apk add --update varnish && rm -rf /var/cache/apk/*

ENV VCL_DIR '/etc/varnish'
ENV VCL_FILE 'default.vcl'
ENV VARNISH_CACHE_SIZE 64m
ENV VARNISH_ADDRESS '0.0.0.0'
ENV VARNISH_PORT 80

COPY start.sh /start.sh
COPY default.vcl $VCL_DIR/$VCL_FILE

EXPOSE $VARNISH_PORT
CMD /start.sh
