ARG BUILD_FROM
FROM $BUILD_FROM

RUN mkdir -p /data/joal \
    &&  curl -L -s \
        "https://github.com/anthonyraymond/joal/releases/download/2.1.24/joal.tar.gz" \
        | tar zxvf - -C /data/joal \
    && chown -R $(id -u):$(id -g) /data/joal \
    && rm -fr \
        /tmp/*

CMD [ "--joal-conf=/data/joal" ]
VOLUME [ "/data" ]
