FROM shiomax/docker-baseimage-gui:debian-10-v3.5.6-arm

ENV URL_PICARD_REPO="https://github.com/metabrainz/picard.git" \
    URL_CHROMAPRINT_REPO="https://github.com/acoustid/chromaprint.git" \
    URL_GOOGLETEST_REPO="https://github.com/google/googletest.git"
    
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN apt-get update && \
    apt-get install -y -f --no-install-recommends \
        picard \
        chromium \
        && \
    # Update OpenBox config
    sed -i 's/<application type="normal">/<application type="normal" title="MusicBrainz Picard">/' /etc/xdg/openbox/rc.xml && \
    sed -i '/<decor>no<\/decor>/d' /etc/xdg/openbox/rc.xml && \
    # Update chromium-browser config
    sed -i 's/Exec=chromium-browser/Exec=chromium-browser --no-sandbox --disable-dev-shm-usage --disable-gpu --disable-software-rasterizer --log-level=3/g' /usr/share/applications/chromium-browser.desktop && \
    # Symlink for fpcalc (issue #32)
    ln -s /usr/local/bin/fpcalc /usr/bin/fpcalc && \
    # Add optical drive script from jlesage/docker-handbrake
    git clone https://github.com/jlesage/docker-handbrake.git /src/docker-handbrake && \
    cp -v /src/docker-handbrake/rootfs/etc/cont-init.d/95-check-optical-drive.sh /etc/cont-init.d/95-check-optical-drive.sh && \
    # Clean-up
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/* && \
    # Capture picard version
    picard -V | grep Picard | cut -d ',' -f 1 | cut -d ' ' -f 2 | tr -d ' ' > /CONTAINER_VERSION

ENV APP_NAME="MusicBrainz Picard" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"
