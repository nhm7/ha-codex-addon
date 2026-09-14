FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash ca-certificates dbus-x11 fonts-dejavu-core git jq locales novnc \
      openssh-client sudo websockify x11vnc xvfb \
      xfce4 xfce4-goodies xfce4-terminal thunar \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY rootfs /
RUN chmod +x /usr/local/bin/desktop-entrypoint
ENV LANG=en_US.UTF-8 DESKTOP_NAME="Ubuntu Xfce desktop" \
    DESKTOP_COMMAND="startxfce4"
WORKDIR /share
EXPOSE 8099
ENTRYPOINT ["/usr/local/bin/desktop-entrypoint"]
LABEL io.hass.version="1.0.0" io.hass.type="addon" \
      org.opencontainers.image.source="https://github.com/nhm7/homeassistant-vm" \
      org.opencontainers.image.licenses="MIT"
