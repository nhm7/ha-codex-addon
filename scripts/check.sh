#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

entrypoint=debian-desktop/rootfs/usr/local/bin/desktop-entrypoint

bash -n "${entrypoint}"
ruby -e 'require "yaml"; %w[repository.yaml debian-desktop/config.yaml debian-desktop/build.yaml .github/workflows/validate.yml].each { |file| YAML.safe_load_file(file, aliases: true) }'

grep -Fq 'amd64: debian:13-slim' debian-desktop/build.yaml
grep -Fq 'google-chrome-stable' debian-desktop/Dockerfile
grep -Fq 'ingress: true' debian-desktop/config.yaml
grep -Fq 'image: ghcr.io/nhm7/homeassistant-vm-debian' debian-desktop/config.yaml
grep -Fq "\`\${base}/websockify\`" debian-desktop/rootfs/usr/share/novnc/index.html
grep -Eq 'x11vnc .* -localhost' "${entrypoint}"

if grep -Eq '^(ports|network|webui|host_dbus|docker_api):' debian-desktop/config.yaml; then
  echo 'The add-on must not expose a host service or privileged host API.' >&2
  exit 1
fi

if find . -maxdepth 1 -type d \( -name 'ubuntu-*' -o -name 'fedora-*' -o -name 'alpine-*' \) | grep -q .; then
  echo 'Only the Debian Home Assistant add-on may be included.' >&2
  exit 1
fi

if find . -type f \
  ! -path './.git/*' \
  ! -path './LICENSE' \
  ! -path './scripts/check.sh' \
  -exec grep -Eil 'railway|docker run|local development|migration' {} + \
  | grep -q .; then
  echo 'Found documentation or code for an unsupported deployment.' >&2
  exit 1
fi

git diff --check
echo 'All repository checks passed.'
