ARG BUILD_FROM=debian:13-slim
FROM ${BUILD_FROM}

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates curl genisoimage novnc qemu-system-x86 qemu-utils socat websockify \
    && mkdir -p /usr/share/debian-vm \
    && cd /usr/share/debian-vm \
    && curl -fsSLO https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2 \
    && curl -fsSLO https://cloud.debian.org/images/cloud/trixie/latest/SHA512SUMS \
    && grep ' debian-13-generic-amd64.qcow2$' SHA512SUMS | sha512sum -c - \
    && rm SHA512SUMS \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /
RUN chmod +x /usr/local/bin/vm-entrypoint

ENV QEMU_ACCEL=tcg
WORKDIR /
EXPOSE 8099
ENTRYPOINT ["/usr/local/bin/vm-entrypoint"]

LABEL io.hass.type="addon" \
      org.opencontainers.image.source="https://github.com/nhm7/homeassistant-desktop-vm" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.description="Persistent Debian desktop VM for Home Assistant Ingress"
