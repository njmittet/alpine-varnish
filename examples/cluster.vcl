vcl 4.1;

import directors;

backend app1 {
  .host = foo.domain.org;
  .port = "9001";
  .probe = {
      .url = "/admin/ping";
      .interval = 1s;
      .timeout = 1s;
      .window = 1;
      .threshold = 1;
    }
}

backend app2 {
  .host = "bar.domain.org";
  .port = "9002";
  .probe = {
      .url = "/admin/ping";
      .interval = 1s;
      .timeout = 1s;
      .window = 1;
      .threshold = 1;
    }
}

sub vcl_init {
    new cluster = directors.round_robin();
    cluster.add_backend(app1);
    cluster.add_backend(app2);
}

sub vcl_recv {
    set req.backend_hint = cluster.backend();
    return(pass);
}
