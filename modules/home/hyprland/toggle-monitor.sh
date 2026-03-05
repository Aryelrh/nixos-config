#!/bin/bash

# Obtiene el estado actual de los monitores
MONITOR_STATE=$(hyprctl monitors | grep -E "name: eDP-1|name: HDMI-A-1" | awk '{print $2}')

# Si el monitor HDMI está activo, lo desactiva y activa el eDP-1
if echo "$MONITOR_STATE" | grep -q "HDMI-A-1"; then
    hyprctl keyword monitor "HDMI-A-1,disable"
    hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
else
    # Si el HDMI está desactivado, lo activa y desactiva el eDP-1
    hyprctl keyword monitor "eDP-1,disable"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@100,0x0,1"
fi
