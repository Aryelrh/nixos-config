#!/usr/bin/env bash

STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

if echo "$STATUS" | grep -q MUTED; then
    echo "󰍭"
else
    echo "󰍬"
fi
