#!/usr/bin/env bash

PROFILE=$(powerprofilesctl get)

case "$PROFILE" in
    power-saver)
        ICON="󰌪"
        LABEL="Power Saver"
        ;;
    balanced)
        ICON="󰾅"
        LABEL="Balanced"
        ;;
    performance)
        ICON="󰓅"
        LABEL="Performance"
        ;;
esac

echo "$ICON $LABEL"
