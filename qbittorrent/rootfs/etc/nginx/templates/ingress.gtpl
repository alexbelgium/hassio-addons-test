server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    {{ if .ssl }}
    include /etc/nginx/includes/ssl_params.conf;
    ssl_certificate /ssl/{{ .certfile }};
    ssl_certificate_key /ssl/{{ .keyfile }};
    proxy_ssl_verify off;
    {{ end }}
    
    location / {
        proxy_pass https://backend$request_uri;
    }
}
