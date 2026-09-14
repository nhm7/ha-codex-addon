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
  grep -Eq 'x11vnc .* -localhost' "${addon}/rootfs/usr/local/bin/desktop-entrypoint"
  ! grep -Eqi 'openssh-server|[^-]sshd' "${addon}/Dockerfile"
  ! grep -Eq '^ports:' "${addon}/config.yaml"
done

legacy_pattern='co''dex|open''ai'
if rg -i "${legacy_pattern}" --glob '!LICENSE' --glob '!.git/**' .; then
  echo 'Legacy product-specific references remain.' >&2
  exit 1
fi

git diff --check
echo 'All repository checks passed.'
