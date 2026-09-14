#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

addons=(ubuntu-desktop debian-desktop alpine-desktop)
for addon in "${addons[@]}"; do
  bash -n "${addon}/rootfs/usr/local/bin/desktop-entrypoint"
  cmp scripts/desktop-entrypoint.sh "${addon}/rootfs/usr/local/bin/desktop-entrypoint"
  cmp scripts/index.html "${addon}/rootfs/usr/share/novnc/index.html"

  for key in name version slug description arch ingress ingress_port panel_icon options schema; do
    grep -Eq "^${key}:" "${addon}/config.yaml"
  done
  grep -Eq '^ingress: true$' "${addon}/config.yaml"
  grep -Eq '^ingress_port: 8099$' "${addon}/config.yaml"
  grep -Eq '^host_network: false$' "${addon}/config.yaml"
  grep -Eq '^apparmor: true$' "${addon}/config.yaml"
  grep -Eq '^homeassistant_api: false$' "${addon}/config.yaml"
  grep -Eq '^hassio_api: false$' "${addon}/config.yaml"
  grep -Eq '^auth_api: false$' "${addon}/config.yaml"
  grep -Eq 'x11vnc .* -localhost' "${addon}/rootfs/usr/local/bin/desktop-entrypoint"
  if grep -Eqi 'openssh-server|[^-]sshd' "${addon}/Dockerfile"; then
    echo "${addon} must not install an SSH server." >&2
    exit 1
  fi
  if grep -Eq '^ports:' "${addon}/config.yaml"; then
    echo "${addon} must not publish host ports." >&2
    exit 1
  fi

  config_version=$(sed -n 's/^version: "\([^"]*\)"$/\1/p' "${addon}/config.yaml")
  grep -Fq "io.hass.version=\"${config_version}\"" "${addon}/Dockerfile"
  grep -Fq 'org.opencontainers.image.source="https://github.com/nhm7/homeassistant-vm"' \
    "${addon}/Dockerfile"
done

legacy_pattern='co''dex|open''ai'
mapfile -t legacy_files < <(
  find . -type f \
    -not -path './.git/*' \
    -not -path './LICENSE' \
    -exec grep -Eil "${legacy_pattern}" {} +
)
if ((${#legacy_files[@]} > 0)); then
  printf '%s\n' "${legacy_files[@]}"
  echo 'Legacy product-specific references remain.' >&2
  exit 1
fi

git diff --check
echo 'All repository checks passed.'
