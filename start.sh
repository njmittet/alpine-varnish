#!/bin/sh

set -e

varnishd -a 0.0.0.0:$VARNISH_PORT -F -f $VCL_CONFIG -s malloc,$CACHE_SIZE
