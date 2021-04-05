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
        allow   172.30.32.2;
        deny    all;
        proxy_pass {{ .protocol }}://backend/;
        proxy_ssl_server_name on;
    }
}
