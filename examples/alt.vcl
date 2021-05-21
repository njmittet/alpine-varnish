vcl 4.1;

backend default {
    .host = "localhost";
    .port = "9000";
}

sub vcl_recv {
    return(pass);
}
