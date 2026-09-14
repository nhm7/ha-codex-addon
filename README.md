# Codex Desktop for Home Assistant

Run the community-maintained Codex CLI in a lightweight graphical Linux desktop
and use it remotely from the Home Assistant sidebar. The add-on targets x86-64
Home Assistant installations, updates Codex whenever it starts, supports custom
environment variables and runs an optional startup script before the desktop.

> [!IMPORTANT]
> This is an independent community project. It is not affiliated with,
> endorsed by, or supported by OpenAI. “OpenAI” and “Codex” are trademarks of
> their respective owner.

## Installation

1. In Home Assistant, open **Settings → Add-ons → Add-on store**.
2. Open the repository menu and add this GitHub repository URL.
3. Install **Codex Desktop**, review its configuration and start it.
4. Enable **Show in sidebar**, then open the remote desktop. Codex starts in the
   desktop terminal. Authentication uses the methods offered by the Codex CLI.

See the [add-on documentation](codex-desktop/DOCS.md) for configuration,
storage, security and troubleshooting details.

## Platform

This repository intentionally ships only the `amd64` image for x86-64 Home
Assistant hosts. It is a Linux container with a virtual display, not a
hardware-virtualized VM.

The repository deliberately contains no binary icon or logo assets. Home
Assistant therefore uses its standard add-on artwork; the sidebar still uses
the configured `mdi:monitor-dashboard` icon.

## Development

```sh
./scripts/check.sh
```

## License

MIT — see [LICENSE](LICENSE).
