#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

addons=(debian-vm debian-vm-kvm)
for addon in "${addons[@]}"; do
  entrypoint="${addon}/rootfs/usr/local/bin/vm-entrypoint"
  bash -n "${entrypoint}"
  ruby -e 'require "yaml"; YAML.safe_load_file(ARGV.fetch(0), aliases: true)' "${addon}/config.yaml"
  ruby -e 'require "yaml"; YAML.safe_load_file(ARGV.fetch(0), aliases: true)' "${addon}/build.yaml"
  grep -Fq 'amd64: debian:13-slim' "${addon}/build.yaml"
  grep -Fq 'qemu-system-x86' "${addon}/Dockerfile"
  grep -Fq 'debian-13-generic-amd64.qcow2' "${addon}/Dockerfile"
  grep -Fq 'ingress: true' "${addon}/config.yaml"
  grep -Fq '/data/debian.qcow2' "${entrypoint}"
  grep -Fq 'system_powerdown' "${entrypoint}"
  grep -Fq "\${base}/websockify" "${addon}/rootfs/usr/share/novnc/index.html"
  if grep -Eq '^(ports|network|webui|host_dbus|docker_api):' "${addon}/config.yaml"; then
    echo "${addon} must not expose a host service or privileged host API." >&2
    exit 1
  fi
done

grep -Fq 'ENV QEMU_ACCEL=tcg' debian-vm/Dockerfile
grep -Fq 'image: ghcr.io/nhm7/homeassistant-vm-debian' debian-vm/config.yaml
grep -Fq 'ENV QEMU_ACCEL=kvm' debian-vm-kvm/Dockerfile
grep -Fq -- '- /dev/kvm' debian-vm-kvm/config.yaml
grep -Fq 'image: ghcr.io/nhm7/homeassistant-vm-debian-kvm' debian-vm-kvm/config.yaml
ruby -e 'require "yaml"; YAML.safe_load_file("repository.yaml", aliases: true); YAML.safe_load_file(".github/workflows/validate.yml", aliases: true)'
grep -Fq 'https://github.com/nhm7/homeassistant-desktop-vm' repository.yaml
grep -Fq 'supervisor_add_addon_repository.svg' README.md
grep -Fq 'repository_url=https%3A%2F%2Fgithub.com%2Fnhm7%2Fhomeassistant-desktop-vm' README.md

git diff --check
echo 'All repository checks passed.'
