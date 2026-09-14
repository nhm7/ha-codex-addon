# Debian Desktop

This Home Assistant add-on provides a Debian 13 Xfce desktop in the Home
Assistant sidebar. Google Chrome, Thunar, a terminal, and Git are preinstalled.

## Configuration

- **resolution**: virtual desktop size in `WIDTHxHEIGHT` form.
- **working_directory**: initial directory for the optional startup script.
- **startup_script**: shell commands run before the desktop starts.
- **environment**: optional `NAME=value` entries for the desktop session.

The desktop automatically follows the size of the Home Assistant panel. Use
the noVNC control bar's **Clipboard** panel to exchange text with the device
running your browser; browsers require this explicit interaction before a
remote page can read or write the system clipboard.

The desktop home directory is stored in the add-on configuration volume.
Home Assistant's `/share` and `/media` directories are also available. Access
is provided only through authenticated Home Assistant Ingress; no VNC or web
port is published on the host.

Chrome is registered as Xfce's default browser and uses a container-compatible
launcher. It runs with `--no-sandbox` because the Home Assistant add-on session
runs as root. Do not use this desktop to browse untrusted sites.
