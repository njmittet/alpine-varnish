# alpine-varnish
[Docker](https://www.docker.com/) image for running [Varnish] (https://www.varnish-cache.org/). Based on [Alpine Linux](http://alpinelinux.org/). 

[Image on Docker Hub](https://hub.docker.com/r/njmittet/alpine-varnish/).

## Usage
Create a Docker image containing your own VCL-file by creating a Dockerfile with the following content:
~~~~
FROM njmittet/alpine-varnish:latest
COPY yourcustom.vcl $VCL_CONFIG
~~~~
The default value of VCL_CONFIG is /etc/varnish/default.vcl.

Create and run the your container (usoing default values):
~~~~
docker build -t myvarnish .
docker run -d myvarnish
~~~~

Customize the values by providing environmental variables to the Docker container.
The belov examples shows running the container with altered values for the VCL-file and maxium memory usage:
~~~~
docker run -e VLC_CONFIG /path/to/custom.vcl CACHE_SIZE=128m myvarnish
~~~~

To change the port Varnish listens to, both the Varnish port and the port exposed by Docker must be changed:
~~~~
docker run -e VARNISH_PORT=9000 --expose=9000 myvarnish
~~~~

## Testing
See the [README in /backend](backend) if you want to test your Varnish configuration using a dummy backend service.

## Examples
See [examples](examples) for other VCL-exampels.

## Varnish Version
This image does not allow configuring the exact Varnish version, and will always use the latest version provided by the current Alpine version used when building the image.
