# backend

This folder contains a JSON file to be served, acting as a backend REST API.

## Usage

1. Install [JSON Server](https://github.com/typicode/json-server) or any other equivalent tool acting as a fake REST API.
2. Serve the file using:
~~~~
json-server --watch db.json
~~~~

The default port is 3000, so access the resouce on `http://localhost:3000/posts`, or change to another port using:

~~~~
json-server --watch db.json --port 8080
~~~~

The latter is reccomended since the default.vcl-file assumes a backend listening on port 8080. If another port is to be uses, a custom VC-file must be provided to the image. This can be done either by creating a custom image containing your file (see the [top level README](../README.md)), or by providing one at runtime: 
~~~~
mkdir vcl
mv my.vcl vcl/
docker run --network host -v $(pwd)/vcl/:/etc/varnish/vcl -e VCL_CONFIG='/etc/varnish/vcl/my.vcl' myvarnish
~~~~

Note the above `docker run -e --network host myvarnish`, letting the dockerized Varnish container communicate with the fake backend running on the host. Works well for testing, but be aware of port collisions.


Verify by calling `curl localhost/posts`