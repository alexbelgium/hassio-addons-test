ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]



COPY run.sh /
RUN chmod 777 /run.sh
ENTRYPOINT [ "/run.sh" ]
