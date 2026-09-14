#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "${repo_root}"

for script in codex-desktop/rootfs/usr/local/bin/* codex-desktop/rootfs/etc/s6-overlay/s6-rc.d/codex-desktop/run; do
  bash -n "${script}"
done

test "$(head -n 1 codex-desktop/rootfs/usr/local/bin/codex-desktop)" = '#!/usr/bin/with-contenv bashio'
grep -q 'bashio::log.info' codex-desktop/rootfs/usr/local/bin/codex-desktop

for required_entry in '^name:' '^version:' '^slug:' '^description:' '^arch:' '^ingress:' '^schema:'; do
  grep -Eq "${required_entry}" codex-desktop/config.yaml || {
    echo "config.yaml does not contain ${required_entry}" >&2
    exit 1
  }
done

grep -Eq '^  - amd64$' codex-desktop/config.yaml
test "$(grep -Ec '^  - (aarch64|armv7)$' codex-desktop/config.yaml)" -eq 0
grep -q 'x11vnc.*-localhost' codex-desktop/rootfs/usr/local/bin/codex-desktop
! grep -Eq 'openssh-server|sshd' codex-desktop/Dockerfile
! grep -q 'py3-websockify' codex-desktop/Dockerfile
grep -q 'websockify==0.13.0' codex-desktop/Dockerfile
grep -q '^FROM ghcr.io/home-assistant/amd64-base:3.22$' codex-desktop/Dockerfile
test ! -e codex-desktop/build.yaml

# Keep the repository text-only. Home Assistant falls back to its standard
# add-on artwork when icon.png and logo.png are not present.
test ! -e codex-desktop/icon.png
test ! -e codex-desktop/logo.png

echo "All checks passed."
