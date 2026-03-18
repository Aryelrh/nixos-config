#!/bin/bash
while true; do
  for i in {0..9}; do
    source="/run/user/$UID/app/com.discordapp.Discord/discord-ipc-$i"
    target="/run/user/$UID/discord-ipc-$i"
    if [ -S "$source" ] && [ ! -L "$target" ]; then
      ln -sf "$source" "$target"
    fi
  done
  sleep 5
done
