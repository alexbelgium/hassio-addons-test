ARG BUILD_FROM
FROM $BUILD_FROM

# RUN mkdir -p /joal
# COPY rootfs/ /joal/
# RUN mv /joal/default.json /joal/config.json

RUN mkdir -p /joal \
    &&  curl -L -s \
        "https://github.com/anthonyraymond/joal/releases/download/2.1.24/joal.tar.gz" \
        | tar zxvf - -C /joal \
    && chown -R $(id -u):$(id -g) /joal \
    && rm -fr \
        /tmp/*

CMD [ "--joal-conf=/joal" ]
VOLUME [ "/data" ]
