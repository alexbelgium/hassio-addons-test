ARG BUILD_FROM
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# MOFIFY DATA PATH

# RUN
RUN java -jar ./jack-of-all-trades-2.0.4.jar --joal-conf="/share/joal-conf/config.json" --spring.main.web-environment=true --server.port=8081

VOLUME [ "/data" ]
