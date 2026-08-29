#!/usr/bin/env bash
# Captura de pantalla estilo GNOME para Sway (grim + slurp + swayimg como overlay):
#  1. Copia la pantalla a un snapshot "congelado"
#  2. Muestra ese snapshot a pantalla completa (overlay, sin info de swayimg)
#  3. Deja seleccionar la región con slurp
#  4. Recorta la región de la imagen congelada, la guarda y la copia al portapapeles
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
img="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
frozen="$(mktemp --suffix=.png)"
errlog="$(mktemp)"
swayimg_pid=""
overlay_id=""

cleanup() {
  rm -f "$frozen" "$errlog"
  [ -n "$overlay_id" ] && swaymsg "[con_id=$overlay_id] kill" >/dev/null 2>&1 || true
}
trap cleanup EXIT

output="$(swaymsg -t get_outputs -r | jq -r '.[] | select(.focused) | .name')"

# 1) Snapshot del output activo = la imagen congelada
if ! grim -o "$output" "$frozen" 2>"$errlog"; then
  notify-send -a Screenshot -u critical "Error al congelar" "grim: $(tail -c 300 "$errlog")"
  exit 1
fi

# 2) Overlay a pantalla completa, ocultando la capa de info de swayimg (lua text.hide)
swaymsg "exec swayimg -e 'swayimg.text.hide()' -F '$frozen'" >/dev/null
sleep 0.4
swayimg_pid="$(pgrep -f '^swayimg' | head -n1 || true)"
[ -z "$swayimg_pid" ] || overlay_id="$(swaymsg -t get_tree -r | jq -r --argjson p "$swayimg_pid" '.. | objects | select(.pid? == $p) | .id' | head -n1)"

# 3) Selección de la región sobre la imagen congelada
# NOTA: NO pasar -o a slurp (ese flag cambia el modo a "seleccionar output").
if ! geom="$(slurp -f '%x %y %w %h')"; then
  notify-send -a Screenshot -u low "Captura cancelada"
  exit 1
fi
read -r X Y W H <<<"$geom"

# 4) Recortar la región desde la imagen congelada (aún visible en el overlay)
if ! grim -g "$X,$Y ${W}x${H}" "$img" 2>"$errlog"; then
  # El contenido real bajo el overlay no cambia: reintenta sobre la pantalla viva
  [ -n "$overlay_id" ] && swaymsg "[con_id=$overlay_id] kill" >/dev/null 2>&1 || true
  if ! grim -g "$X,$Y ${W}x${H}" "$img" 2>>"$errlog"; then
    notify-send -a Screenshot -u critical "Error al guardar" "$(tail -c 300 "$errlog")"
    exit 1
  fi
fi

wc -c < "$img" | grep -q "^[1-9]" || {
  notify-send -a Screenshot -u critical "Error al guardar" "La imagen quedó vacía"
  exit 1
}

wl-copy < "$img" 2>>"$errlog" || {
  notify-send -a Screenshot -u critical "Error en portapapeles" "wl-copy: $(tail -c 200 "$errlog")"
  exit 1
}
notify-send -i "$img" -a "Screenshot" "Captura guardada" "$(basename "$img")"