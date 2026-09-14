# Alpine Desktop

Alpine Desktop provides a browser-accessible Openbox with PCManFM and LXTerminal Linux desktop inside a Home
Assistant add-on container. Open it with **Show in sidebar** after starting the
add-on.

## Configuration

```yaml
environment:
  - MY_VARIABLE=value
startup_script: |
  echo "Desktop starting"
working_directory: /share
resolution: 1440x900
```

- **`environment`** adds `NAME=value` entries to the desktop session.
- **`startup_script`** runs as root before the display starts. A failure stops
  the add-on and is visible in its log.
- **`working_directory`** is used while running the startup script. `/config`,
  `/share`, and `/media` are persistent mapped locations.
- **`resolution`** sets the virtual screen size. The noVNC client then scales
  that screen to the available sidebar panel.

## Security and persistence

VNC listens only on container loopback and has no published port. noVNC is
reachable through authenticated Home Assistant Ingress on port 8099. Do not put
an external reverse proxy directly in front of that internal port. No SSH server,
host network, Home Assistant API, or Supervisor API access is enabled.

This is a container rather than a hardware VM: it has a separate userspace and
filesystem but shares the host kernel. The graphical session is ephemeral;
store files that must survive upgrades in `/config`, `/share`, or `/media`.
