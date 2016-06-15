alpine-varnish
==============
[Docker](https://www.docker.com/) image for running [Varnish] (https://www.varnish-cache.org/). Based on [Alpine Linux](http://alpinelinux.org/). 

[Image on Docker Hub](https://hub.docker.com/r/njmittet/alpine-varnish/).

Usage
-----
Create a Docker image containing your own Varnish VCL-file:
~~~~
FROM njmittet/alpine-varnish:latest
COPY custom.vcl $VCL_CONFIG
~~~~
The default value of VCL_CONFIG is /etc/varnish/default.vcl.

Create and run the your container with default values:
~~~~
docker build -t myvarnish .
docker run -d myvarnish
~~~~

Run your container with custom values for the VCL-file and maxium memory usage:
~~~~
docker run -e VLC_CONFIG /path/to/custom.vcl CACHE_SIZE=128m myvarnish
~~~~

Versions
--------
Will always use the latest version provided by the Alpine Linux version.
