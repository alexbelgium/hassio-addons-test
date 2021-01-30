ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

#Install last version https://github.com/dvershinin/lastversion
RUN pip install --upgrade pip \
    && pip install lastversion

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
