ARG BUILD_FROM
FROM $BUILD_FROM

RUN mkdir p /joal
COPY rootfs/ /joal/
# RUN mv /joal/default.json /joal/config.json

# RUN mkdir p /data/joal2 \
#    &&  curl -L -s \
#        "https://github.com/anthonyraymond/joal/releases/download/2.1.24/joal.tar.gz" \
#        | tar zxvf - -C /data/joal2 \
#    && chown -R $(id -u):$(id -g) /data/joal2 \
#    && rm -fr \
#        /tmp/*

CMD [ "--joal-conf=/joal" ]
VOLUME [ "/data" ]
