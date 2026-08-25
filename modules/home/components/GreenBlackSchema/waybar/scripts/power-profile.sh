#!/usr/bin/env bash

command -v powerprofilesctl >/dev/null 2>&1 || exit 0

CURRENT=$(powerprofilesctl get)

case "$CURRENT" in
    power-saver)
        powerprofilesctl set balanced
        ;;
    balanced)
        powerprofilesctl set performance
        ;;
    performance)
        powerprofilesctl set power-saver
        ;;
esac
