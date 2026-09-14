FROM debian:12-slim

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash ca-certificates dbus-x11 fonts-dejavu-core git jq locales novnc \
      openssh-client websockify x11vnc xvfb \
      xfce4 xfce4-terminal thunar \
    && sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY rootfs /
RUN chmod +x /usr/local/bin/desktop-entrypoint
ENV LANG=en_US.UTF-8 DESKTOP_NAME="Debian Xfce desktop" \
    DESKTOP_COMMAND="startxfce4"
WORKDIR /share
EXPOSE 8099
ENTRYPOINT ["/usr/local/bin/desktop-entrypoint"]
LABEL io.hass.version="1.0.0" io.hass.type="addon" \
      org.opencontainers.image.source="https://github.com/nhm7/homeassistant-vm" \
      org.opencontainers.image.licenses="MIT"
