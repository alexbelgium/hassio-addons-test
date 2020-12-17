ARG BUILD_FROM
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# MOFIFY DATA PATH
RUN java -jar ./jack-of-all-trades-X.X.X.jar --joal-conf="/share/joal-conf/config.json" --spring.main.web-environment=true --server.port=8081 --joal.ui.path.prefix="aze" --joal.ui.secret-token="aze"

VOLUME [ "/data" ]