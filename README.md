# Home Assistant Desktop VMs

Browser-accessible Linux desktops for the Home Assistant sidebar. Choose the
image that fits your needs and preferred resource footprint.

> [!NOTE]
> Home Assistant add-ons are containers, not hardware-virtualized machines.
> These add-ons provide VM-like, isolated Linux userspaces while sharing the
> Home Assistant host kernel.

## Available add-ons

| Add-on | Base | Desktop | Best for |
| --- | --- | --- | --- |
| **Ubuntu Desktop** | Ubuntu 24.04 LTS | Xfce | A complete, familiar Ubuntu workspace |
| **Debian Desktop** | Debian 12 | Xfce | A stable, moderately sized workspace |
| **Alpine Desktop** | Alpine 3.22 | Openbox | The smallest and lightest workspace |

## Installation

1. In Home Assistant, open **Settings → Add-ons → Add-on store**.
2. Open the repository menu and add
   `https://github.com/nhm7/homeassistant-vm`.
3. Install one of the desktop add-ons and start it.
4. Enable **Show in sidebar** and open the desktop there.

The browser client scales to the sidebar panel. VNC binds only to the add-on's
loopback interface; the browser endpoint is exposed solely through authenticated
Home Assistant Ingress. No host port or SSH server is exposed.

See each add-on's `DOCS.md` for configuration and security details.

## Development

```sh
./scripts/check.sh
```

The GitHub Actions workflow validates metadata and shell scripts, scans the
images with Hadolint, and builds every add-on for `amd64` on pull requests and
pushes.

## License

MIT — see [LICENSE](LICENSE).
