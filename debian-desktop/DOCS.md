# Debian Desktop

This Home Assistant add-on provides a Debian 13 Xfce desktop in the Home
Assistant sidebar. Google Chrome, Thunar, a terminal, and Git are preinstalled.

## Configuration

No configuration is required. The desktop automatically follows the available
size of the Home Assistant panel without a surrounding noVNC border.

Browser clipboard permissions permitting, Ctrl+C and Ctrl+V exchange text
directly between the local device and Debian. Browser security policies can
still require clipboard permission for the Home Assistant page.

The standard root home directory, `/root`, is stored on the add-on's persistent
data volume.
Home Assistant's `/share` and `/media` directories are also available. Access
is provided only through authenticated Home Assistant Ingress; no VNC or web
port is published on the host.

Chrome is registered as Xfce's default browser and uses a container-compatible
launcher. It runs with `--no-sandbox` because the Home Assistant add-on session
runs as root. Do not use this desktop to browse untrusted sites.
