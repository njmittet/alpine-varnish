# alpine-varnish
A [Docker](https://www.docker.com/) image, based on [Alpine Linux](http://alpinelinux.org/), for running 
[Varnish HTTP Cache](https://www.varnish-cache.org/). This README only aims at getting you up and running with the Docker image, and documents only a very basic usage of Varnish. Consult the [Varnish Documentation](https://varnish-cache.org/docs/) for more details.

For details about the image and its builds, see the [Docker Hub](https://hub.docker.com/r/njmittet/alpine-varnish/) page.

## Defaults
* Varnish listens on port 80.
* The default.vcl assumes a backend listening on localhost:8080.
* The default.vcl location us `/etc/varnish/default.vcl`

### Environmental Variables
The images uses the following environmental variables. See the [varnishd documentation](https://varnish-cache.org/docs/6.0/reference/varnishd.html) for more details.
~~~
VCL_DIR '/etc/varnish'
VCL_FILE 'default.vcl'
VARNISH_CACHE_SIZE 64m
VARNISH_ADDRESS '0.0.0.0' 
VARNISH_PORT 80
~~~

## Dummy Backend
A dummy backend JSON REST API is provided in order to ease testing:
1. Install [JSON Server](https://github.com/typicode/json-server) or any other equivalent dummy backend tool.
2. Serve the file using:
~~~~
json-server --watch backend/db.json
~~~~

The default JSON server port is 3000, so access the resouce on `http://localhost:3000/posts`, or change to another port using `json-server --watch db.json --port 8080`. The latter is reccomended since the default.vcl-file assumes a backend listening on port 8080. Verify that the dummy backend is running with `curl localhost:3000/posts` or `curl localhost:8080/posts`.

## Usage
The image can be used directly or act as a base for you own image. 

### Use Directly
Out of the box the image assumes a backend on localhost:8080, which implies that the docker image has to be on the same network as the host, which works well for testing, but be aware of port collisions.
~~~
docker run -it --rm --name myvarnish --network host njmittet/alpine-varnish
~~~
Verify that Varnish works by requesting on port 80: `curl localhost/posts`.

Run with a different VCL-file using [bind mounts](https://docs.docker.com/v17.09/engine/admin/volumes/bind-mounts/):
~~~~
# Replace default.vcl.
docker run -it --rm --name myvarnish --network host -v $(pwd)/my.vcl:/etc/varnish/default.vcl:ro  njmittet/alpine-varnish

# Use a VCl file with a different name. 
docker run -it --rm --name myvarnish --network host -v $(pwd)/my.vcl:/etc/varnish/my.vcl:ro -e VCL_FILE='my.vcl' njmittet/alpine-varnish
~~~~

To change the port Varnish listens on, both the Varnish port and the port exposed by Docker must be changed:
~~~~
docker run -it --rm --name myvarnish --network host -e VARNISH_PORT=9000 --expose=9000 njmittet/alpine-varnish
~~~~

### Use As Base Image

Create a Docker image containing your own VCL-file by creating a Dockerfile with the following content:
~~~~
FROM njmittet/alpine-varnish:latest
COPY my.vcl $VCL_DIR/default.vcl
~~~~

Create and run the your container:
~~~~
docker build -t myvarnish .
$ docker run -it --rm --name myvarnish --network host myvarnish
~~~~

## VCL Examples
See [examples](https://github.com/njmittet/alpine-varnish/tree/master/examples) foran example cluster VCL-file. Consult the [Varnish VCL Examples](http://varnish-cache.org/trac/wiki/VCLExamples) for a great list of other examples.

## Varnish Version
This image does not allow configuring the exact Varnish version, and will always use the latest version provided by the current Alpine version used when building the image.