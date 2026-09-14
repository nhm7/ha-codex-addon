ARG BUILD_FROM=debian:13-slim
FROM ${BUILD_FROM}

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      adwaita-icon-theme arc-theme bash ca-certificates curl dbus-x11 \
      fonts-dejavu-core fonts-liberation git gnupg locales mousepad \
      novnc papirus-icon-theme websockify x11vnc x11-xserver-utils xvfb \
      xfce4 xfce4-goodies xfce4-terminal thunar \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
      | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && sed -i 's|/usr/bin/google-chrome-stable|/usr/local/bin/google-chrome|g' \
      /usr/share/applications/google-chrome.desktop \
    && sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /
RUN chmod +x /usr/local/bin/desktop-entrypoint /usr/local/bin/google-chrome \
    && update-alternatives --install /usr/bin/x-www-browser x-www-browser \
      /usr/local/bin/google-chrome 200 \
    && update-alternatives --set x-www-browser /usr/local/bin/google-chrome

ENV LANG=en_US.UTF-8
WORKDIR /
EXPOSE 8099
ENTRYPOINT ["/usr/local/bin/desktop-entrypoint"]

LABEL io.hass.type="addon" \
      org.opencontainers.image.source="https://github.com/nhm7/homeassistant-vm" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.description="Debian Xfce desktop for Home Assistant Ingress"
