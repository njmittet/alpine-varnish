#!/bin/sh

set -e

varnishd -a $VARNISH_ADDRESS:$VARNISH_PORT -F -f $VCL_DIR/$VCL_FILE -s malloc,$VARNISH_CACHE_SIZE
