FROM alpine:3.22

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --no-cache \
      bash ca-certificates dbus font-dejavu git jq lxterminal novnc openbox \
      openssh-client pcmanfm py3-numpy py3-pip x11vnc xvfb \
    && pip3 install --no-cache-dir --break-system-packages websockify==0.13.0
COPY rootfs /
RUN chmod +x /usr/local/bin/desktop-entrypoint
ENV DESKTOP_NAME="Alpine Openbox desktop" \
    DESKTOP_COMMAND="openbox-session & pcmanfm --desktop --profile ha-desktop; wait"
WORKDIR /share
EXPOSE 8099
ENTRYPOINT ["/usr/local/bin/desktop-entrypoint"]
LABEL io.hass.version="1.0.0" io.hass.type="addon" \
      org.opencontainers.image.source="https://github.com/nhm7/homeassistant-vm" \
      org.opencontainers.image.licenses="MIT"
