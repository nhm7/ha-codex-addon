#!/usr/bin/env bash
set -Eeuo pipefail

readonly OPTIONS_FILE=/data/options.json
readonly RUNTIME_DIR=/run/ha-desktop
readonly DISPLAY=:0
pids=()

log() { printf '[ha-desktop] %s\n' "$*"; }
cleanup() {
  log 'Stopping desktop services...'
  ((${#pids[@]} == 0)) || kill "${pids[@]}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

[[ -f "${OPTIONS_FILE}" ]] || { log "Missing ${OPTIONS_FILE}"; exit 1; }
mkdir -p "${RUNTIME_DIR}" /config/home /share /media
chmod 700 "${RUNTIME_DIR}" /config/home

resolution=$(jq -r '.resolution // "1440x900"' "${OPTIONS_FILE}")
[[ "${resolution}" =~ ^[0-9]{3,4}x[0-9]{3,4}$ ]] || resolution=1440x900
working_directory=$(jq -r '.working_directory // "/share"' "${OPTIONS_FILE}")
if [[ ! -d "${working_directory}" ]]; then
  log "Working directory ${working_directory} does not exist; using /share."
  working_directory=/share
fi

export HOME=/config/home
export USER=root
export LOGNAME=root
export DISPLAY
export XDG_RUNTIME_DIR="${RUNTIME_DIR}/xdg"
mkdir -p "${XDG_RUNTIME_DIR}"
chmod 700 "${XDG_RUNTIME_DIR}"

while IFS= read -r entry; do
  [[ -z "${entry}" ]] && continue
  name=${entry%%=*}
  value=${entry#*=}
  if [[ "${entry}" != *=* || ! "${name}" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    log 'Ignoring an invalid environment entry.'
    continue
  fi
  export "${name}=${value}"
done < <(jq -r '.environment[]? // empty' "${OPTIONS_FILE}")

startup_file="${RUNTIME_DIR}/startup.sh"
jq -r '.startup_script // ""' "${OPTIONS_FILE}" > "${startup_file}"
chmod 700 "${startup_file}"
cd "${working_directory}"
log 'Running startup script...'
bash "${startup_file}"

log "Starting virtual display at ${resolution}..."
Xvfb "${DISPLAY}" -screen 0 "${resolution}x24" -nolisten tcp -noreset &
pids+=("$!")
for _ in $(seq 1 100); do
  [[ -S /tmp/.X11-unix/X0 ]] && break
  sleep 0.1
done
[[ -S /tmp/.X11-unix/X0 ]] || { log 'Virtual display failed to start.'; exit 1; }

if command -v dbus-launch >/dev/null; then
  eval "$(dbus-launch --sh-syntax)"
fi

log "Starting ${DESKTOP_NAME}..."
bash -lc "${DESKTOP_COMMAND}" &
pids+=("$!")

log 'Starting loopback-only VNC and Home Assistant Ingress gateway...'
x11vnc -display "${DISPLAY}" -localhost -rfbport 5900 -forever -shared -nopw -noxdamage &
pids+=("$!")
websockify --web=/usr/share/novnc 8099 localhost:5900 &
gateway_pid=$!
pids+=("${gateway_pid}")
wait "${gateway_pid}"
