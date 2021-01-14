ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    lua-resty-http=0.15-r0 \
    nginx-mod-http-lua=1.18.0-r1 \
    nginx=1.18.0-r1 \
    && rm -fr \
    /etc/nginx \
    /tmp/*

# Copy root filesystem
COPY rootfs /
COPY run.sh /
RUN chmod 777 /run.sh
RUN chown root:root /run.sh
CMD [ "" ]
ENTRYPOINT [ "sh /run.sh" ]

VOLUME ["/ssl", "/data"]
