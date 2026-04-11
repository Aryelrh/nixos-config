#!/usr/bin/env bash

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
