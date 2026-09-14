# Changelog

## 0.2.1

- Fix image builds on Alpine 3.22 by installing websockify from PyPI instead of
  requesting the unavailable `py3-websockify` APK package.
- Move the amd64 base image and OCI labels into the Dockerfile because
  `build.yaml` is deprecated by Home Assistant Supervisor.
- Replace placeholder project URLs with the real repository URL.

## 0.2.0

- Replace the terminal-only UI with an Openbox Linux desktop through noVNC.
- Target x86-64 (`amd64`) Home Assistant systems exclusively.
- Add a configurable desktop resolution and automatic browser reconnection.
- Keep automatic Codex updates, startup scripts, environment variables,
  persistent authentication and structured lifecycle logs.
- Use Home Assistant's default add-on artwork so the repository remains
  text-only.
