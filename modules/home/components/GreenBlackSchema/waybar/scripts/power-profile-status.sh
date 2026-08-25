#!/usr/bin/env bash

command -v powerprofilesctl >/dev/null 2>&1 || { echo "󰾅"; exit 0; }

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
