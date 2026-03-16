#!/usr/bin/env bash

# Lock screen before suspend
swaylock -f -c 1a1a1a &&

# Suspend the system
systemctl suspend
