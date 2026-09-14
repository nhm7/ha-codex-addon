FROM ghcr.io/home-assistant/amd64-base:3.22

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
        py3-numpy \
        py3-pip \
        ripgrep \
        ttf-dejavu \
        x11vnc \
        xvfb \
    && npm config set update-notifier false \
    && npm cache clean --force \
    && pip3 install --no-cache-dir --no-deps --break-system-packages websockify==0.13.0

COPY rootfs /

RUN chmod +x \
        /etc/s6-overlay/s6-rc.d/codex-desktop/run \
        /usr/local/bin/codex-session \
        /usr/local/bin/codex-desktop

WORKDIR /share

LABEL io.hass.version="0.2.2" \
      io.hass.type="addon" \
      io.hass.arch="amd64" \
      org.opencontainers.image.title="Codex Desktop Community Add-on" \
      org.opencontainers.image.description="Browser-accessible Linux desktop with Codex CLI for Home Assistant" \
      org.opencontainers.image.source="https://github.com/nhm7/ha-codex-addon" \
      org.opencontainers.image.licenses="MIT"
