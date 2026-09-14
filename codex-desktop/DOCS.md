# Codex Desktop

Codex Desktop provides a lightweight graphical Linux environment through Home
Assistant Ingress. noVNC renders an Openbox desktop in the browser; PCManFM
provides desktop/file management and LXTerminal starts the current Codex CLI.
The add-on is intentionally available only for x86-64 (`amd64`) hosts.

## Configuration

```yaml
environment:
  - OPENAI_API_KEY=replace-me
  - MY_PROJECT_MODE=development
startup_script: |
  git config --global user.name "Home Assistant"
  echo "Container is ready"
working_directory: /share
codex_arguments:
  - --search
resolution: 1440x900
```

### `environment`

A list of `NAME=value` strings. Names must use shell environment-variable
syntax. Values are never printed by the launcher. Home Assistant stores add-on
options in its configuration, so use secrets carefully and never paste options
into support requests.

### `startup_script`

A Bash script run once after environment setup and the Codex update, but before
the graphical desktop starts. A non-zero exit stops the add-on so the error is
visible in the add-on log.

### `working_directory`

The initial Codex directory. `/share`, `/media`, and `/config` are persistent
mapped locations. `/config` is this add-on's private configuration directory,
not Home Assistant's main configuration directory. Other paths may be erased
when the add-on is rebuilt or upgraded.

### `codex_arguments`

Optional arguments passed directly to `codex`, one argument per list item.

### `resolution`

Virtual desktop resolution in `WIDTHxHEIGHT` form, for example `1920x1080`.
The default is `1440x900`. noVNC scales the desktop to the available browser
area.

## Updates, desktop and authentication

At every start, the add-on installs the newest published `@openai/codex` npm
package. Startup therefore requires internet access and intentionally fails if
the update cannot be completed. Authentication files persist in
`/config/codex`. Codex opens automatically in LXTerminal. If it exits, the
terminal remains open as a Bash shell; restart Codex with `codex` or restart the
add-on to update it first.

The desktop session is not preserved across add-on restarts, but files in
`/config`, `/share`, and `/media` are persistent. Browser reconnects attach to
the currently running desktop.

## Security model

- No SSH server is installed and no SSH port is exposed. `openssh-client` only
  enables outbound Git/SSH connections.
- VNC listens only on container loopback. It is not exposed as an add-on port.
- Only noVNC is available through authenticated Home Assistant Ingress.
- The add-on requests no host networking, Home Assistant API, Supervisor API or
  access to Home Assistant's primary configuration.
- This is a Linux **container**, not a hardware-virtualized VM. It has its own
  userspace and filesystem but shares the host kernel.
- noVNC has no separate password because access is gated by Home Assistant
  Ingress. Never expose port 7681 through a manual proxy that bypasses Home
  Assistant authentication.

## Logs and troubleshooting

The add-on log reports the Codex update, installed version, startup-script
execution, virtual display startup and web desktop startup. Secret environment
values are omitted. A blank screen usually means the selected resolution is too
large for available memory; try `1280x720`. If the add-on does not start, inspect
the log for the first fatal message.

## Independence notice

This add-on is an independent community project. It is not affiliated with,
endorsed by, sponsored by, or supported by OpenAI. OpenAI and Codex are
trademarks of their respective owner.
