upstream backend {
    server 127.0.0.1:{{ .port }}/web/dashboard;
}
