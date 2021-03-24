server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    server_name scrutiny.*;
    client_max_body_size 0;

    location / {
        allow   172.30.32.2;
        allow   172.30.33.2;
        deny    all;
        proxy_pass {{ .protocol }}://backend;
    }
}
