FROM alpine:3.10

MAINTAINER Nils Jørgen Mittet <njmittet@gmail.com>

RUN apk add --update varnish && rm -rf /var/cache/apk/*

ENV VCL_CONFIG '/etc/varnish/default.vcl'
ENV CACHE_SIZE 64m
ENV VARNISH_PORT 80

COPY start.sh /start.sh
COPY default.vcl $VCL_CONFIG

CMD /start.sh
EXPOSE $VARNISH_PORT
