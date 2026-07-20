{ lib, stdenv, bash, wmctrl, coreutils, gnugrep, gawk, procps }:

stdenv.mkDerivation {
  pname = "dynamic-workspaces";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/dynamic-workspaces << 'SCRIPT'
#!${bash}/bin/bash
# Dynamic Workspaces for XFCE/xfwm4
# Mimics GNOME's dynamic workspaces behavior:
#   - Auto-creates a new workspace when the last one is occupied
#   - Auto-removes empty workspaces at the end (keeps at least 1)
# Lightweight implementation using wmctrl.

readonly POLL_INTERVAL=1
readonly MIN_WORKSPACES=1
readonly MAX_WORKSPACES=36

# XFWM4 can be told to sync workspace count with xfconf
# We use wmctrl for all operations since xfwm4 responds to EWMH

# Get current workspace count
workspace_count() {
  ${wmctrl}/bin/wmctrl -d | ${coreutils}/bin/wc -l
}

# Get number of windows on a given workspace (by number)
windows_on_workspace() {
  local ws="$1"
  ${wmctrl}/bin/wmctrl -l | ${gnugrep}/bin/grep "^0x" | ${coreutils}/bin/cut -d' ' -f3 | ${gnugrep}/bin/grep -c "^$ws$"
}

# Get current active workspace
active_workspace() {
  ${wmctrl}/bin/wmctrl -d | ${gnugrep}/bin/grep '\*' | ${gawk}/bin/awk '{print $1}'
}

# Set number of workspaces
set_workspace_count() {
  local count="$1"
  ${wmctrl}/bin/wmctrl -n "$count"
}

cleanup() {
  exit 0
}

trap cleanup SIGTERM SIGINT SIGHUP

# Main loop
while true; do
  sleep "$POLL_INTERVAL"

  total=$(workspace_count)
  active=$(active_workspace)

  # Ignore spurious results
  [ -z "$total" ] || [ -z "$active" ] && continue
  [ "$total" -lt 1 ] && continue

  last=$((total - 1))

  # Check if we're on the last workspace and it has windows -> create new one
  if [ "$active" -eq "$last" ] && [ "$total" -lt "$MAX_WORKSPACES" ]; then
    wins=$(windows_on_workspace "$active")
    if [ "$wins" -gt 0 ]; then
      set_workspace_count $((total + 1))
    fi
  fi

  # Remove empty trailing workspaces (keep at least MIN_WORKSPACES)
  while true; do
    total=$(workspace_count)
    [ "$total" -le "$MIN_WORKSPACES" ] && break

    last=$((total - 1))
    wins=$(windows_on_workspace "$last")
    if [ "$wins" -eq 0 ]; then
      set_workspace_count $((total - 1))
    else
      break
    fi
  done
done
SCRIPT

    chmod +x $out/bin/dynamic-workspaces
  '';

  meta = with lib; {
    description = "Dynamic workspaces daemon for XFCE/xfwm4 (GNOME-like auto workspace management)";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [];
  };
}
