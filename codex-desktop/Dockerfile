ARG BUILD_FROM
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
        bash \
        ca-certificates \
        dbus \
        git \
        jq \
        lxterminal \
        nodejs \
        npm \
        novnc \
        openbox \
        openssh-client-default \
        pcmanfm \
        py3-websockify \
        ripgrep \
        ttf-dejavu \
        x11vnc \
        xvfb \
    && npm config set update-notifier false \
    && npm cache clean --force

COPY rootfs /

RUN chmod +x \
        /etc/s6-overlay/s6-rc.d/codex-desktop/run \
        /usr/local/bin/codex-session \
        /usr/local/bin/codex-desktop

WORKDIR /share

LABEL io.hass.version="0.2.0" \
      io.hass.type="addon" \
      io.hass.arch="amd64"
