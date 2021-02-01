ARG BUILD_FROM
FROM $BUILD_FROM

VOLUME [ "/data" ]

RUN \
    apk add --no-cache git \
    && pip install --upgrade pip \
    && pip install nodejs npm \
	&& cd /data \
	&& git clone https://github.com/tobim-dev/cookidoo-scraper-simple.git

# Copy script
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh"] 

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
