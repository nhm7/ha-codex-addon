# Debian Desktop for Home Assistant

[![Open your Home Assistant instance and add this repository](https://my.home-assistant.io/badges/supervisor_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fnhm7%2Fhomeassistant-vm)

A Debian 13 Xfce desktop available as a Home Assistant add-on and opened from
the Home Assistant sidebar. It includes Google Chrome Stable, Thunar, a
terminal, and Git.

> [!NOTE]
> Home Assistant add-ons are containers rather than hardware virtual machines.
> This provides a complete Debian userspace while sharing the host kernel.

## Install

1. Use the badge above, or open **Settings → Add-ons → Add-on store** in Home
   Assistant and add `https://github.com/nhm7/homeassistant-vm` as a repository.
2. Install **Debian Desktop**.
3. Start the add-on and enable **Show in sidebar**.
4. Open **Debian Desktop** from the sidebar.

The browser connection is available only through authenticated Home Assistant
Ingress. The add-on publishes no host port and does not run an SSH server.

The desktop home persists in the add-on configuration volume. `/share` and
`/media` are available inside the desktop. See the add-on's Configuration tab
and [documentation](debian-desktop/DOCS.md) for its four optional settings.

## License

MIT — see [LICENSE](LICENSE).
