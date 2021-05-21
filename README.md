# alpine-varnish

A [Docker](https://www.docker.com/) image running
[Varnish HTTP Cache](https://www.varnish-cache.org/), based on [Alpine Linux](http://alpinelinux.org/).

This README only aims at getting you up and running with the Docker image, and documents only a very basic usage of Varnish. Consult the [Varnish Documentation](https://varnish-cache.org/docs/) for more details.

For details about the Docker image and related builds, see the [Docker Hub](https://hub.docker.com/r/njmittet/alpine-varnish/) page.

## Versions

The image is based on [alpine-3](https://hub.docker.com/_/alpine) and provides [Varnish Cache 6.5.1](https://varnish-cache.org/releases/rel6.5.1.html), which has EOL date 2022-09-15.

## TLS Termination

This image is created for development purposes (e.g for testing how load balanced backends behaves), and does not support SSL/TLS termination. See [How to configure Varnish with SSL termination](https://stackoverflow.com/questions/61977794/how-to-configure-varnish-with-ssl-termination-on-ubuntu-18-04) using the Hitch TLS proxy for details.

If you require TLS termination, use the official [Varnish Docker image](https://hub.docker.com/_/varnish) instead.

## Defaults

- Varnish listens on port 80.
- The default.vcl assumes a backend listening on localhost:8080.
- The default.vcl location us `/etc/varnish/default.vcl`

### Environmental Variables

The images uses the following environmental variables. See the [varnishd documentation](https://varnish-cache.org/docs/6.0/reference/varnishd.html) for more details.

```DOCKER
VCL_DIR '/etc/varnish'
VCL_FILE 'default.vcl'
VARNISH_CACHE_SIZE 64m
VARNISH_ADDRESS '0.0.0.0'
VARNISH_PORT 80
```

## Dummy Backend

A dummy backend JSON REST API is provided in order to ease testing:

1. Install [JSON Server](https://github.com/typicode/json-server) or any other equivalent dummy backend tool.
2. Serve the file using:

```SH
# The default JSON server port is 3000, but since the default VCL-file assues a backend rinning on port 8080.
$ json-server --watch backend/db.json --port 8080
```

Verify that the dummy backend is running with:

```SH
$ curl localhost:8080/posts
# Should return:
[
  {
    "id": 1,
    "title": "json-server",
    "author": "typicode"
  }
]
```

## Usage

The image can be used directly or as a base for you own image.

### Use Directly

Out of the box the image assumes a backend on localhost:8080, which implies that the docker image has to be on the same network as the host. That works well for testing, but be aware of port collisions.

```SH
docker run -it --rm --name myvarnish --network host njmittet/alpine-varnish
```

Verify that Varnish works by requesting on port 80:

```SH
$ curl localhost/posts
# Should return:
[
  {
    "id": 1,
    "title": "json-server",
    "author": "typicode"
  }
]
```

Run with a different VCL-file using [bind mounts](https://docs.docker.com/v17.09/engine/admin/volumes/bind-mounts/):

```SH
# Replace the default.vcl file.
$ docker run -it --rm --name myvarnish --network host -v $(pwd)/alt.vcl:/etc/varnish/default.vcl:ro njmittet/alpine-varnish

# Use a VCL file with a different name.
$ docker run -it --rm --name myvarnish --network host -v $(pwd)/alt.vcl:/etc/varnish/alt.vcl:ro -e VCL_FILE='alt.vcl' njmittet/alpine-varnish
```

To change the port Varnish listens on, both the Varnish port and the port exposed by Docker must be changed:

```SH
docker run -it --rm --name myvarnish --network host -e VARNISH_PORT=9000 --expose=9000 njmittet/alpine-varnish
```

### Use As Base Image

Create an image containing your own VCL-file by creating a Dockerfile with the following content:

```DOCKER
FROM njmittet/alpine-varnish:latest
COPY alt.vcl $VCL_DIR/default.vcl
```

```SH
# Build and run the container.
$ docker build -t myvarnish .
$ docker run -it --rm --name myvarnish --network host myvarnish
```

## VCL Examples

See the [examples](https://github.com/njmittet/alpine-varnish/tree/master/examples) for a cluster example. Consult the [Varnish VCL Examples](http://varnish-cache.org/trac/wiki/VCLExamples) for a great list of other examples.
