#!/usr/bin/env bash
# Control del backlight del teclado (MacBook Air) vía sysfs
# (smc::kbd_backlight, driver applesmc; write access vía regla udev)
set -euo pipefail

led=/sys/class/leds/smc::kbd_backlight
errlog="$(mktemp)"
trap 'rm -f "$errlog"' EXIT

max="$(cat "$led/max_brightness")"
cur="$(cat "$led/brightness")"
step=$(( (max + 4) / 5 ))

case "${1:-}" in
  up)
    new=$((cur + step))
    [ "$new" -gt "$max" ] && new=$max
    ;;
  down)
    new=$((cur - step))
    [ "$new" -lt 0 ] && new=0
    ;;
  *)
    exit 1
    ;;
esac

if ! printf '%s' "$new" > "$led/brightness" 2>"$errlog"; then
  notify-send -a "Backlight" -u critical "Error de backlight" "$(tail -c 200 "$errlog")"
  exit 1
fi