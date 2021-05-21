vcl 4.1;

import directors;

backend api1 {
    .host = "localhost";
    .port = "9001";
}

backend api2 {
    .host = "localhost";
    .port = "9002";
}

sub vcl_init {
    new cluster = directors.round_robin();
    cluster.add_backend(api1);
    cluster.add_backend(api2);
}

sub vcl_recv {
    set req.backend_hint = cluster.backend();
    return(pass);
}
