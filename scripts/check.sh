#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

bash -n rootfs/usr/local/bin/desktop-entrypoint
python3 -m json.tool railway.json >/dev/null

grep -Fq 'FROM debian:12-slim' Dockerfile
grep -Fq 'google-chrome-stable' Dockerfile
grep -Fq 'healthcheckPath": "/healthz"' railway.json
grep -Fq "PASSWORD must be set" rootfs/usr/local/bin/desktop-entrypoint
grep -Eq 'x11vnc .* -localhost' rootfs/usr/local/bin/desktop-entrypoint

if find . -maxdepth 1 -type d \( -name 'ubuntu-*' -o -name 'fedora-*' -o -name 'alpine-*' \) | grep -q .; then
  echo 'Only the Debian desktop may be included.' >&2
  exit 1
fi

git diff --check
echo 'All repository checks passed.'
