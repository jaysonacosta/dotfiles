#!/bin/bash

for iface in $(networksetup -listallhardwareports | awk '/Hardware Port:/ && !/Wi-Fi/{getline; print $2}'); do
    if ipconfig getifaddr "$iface" &>/dev/null; then
        sketchybar --set "$NAME" icon="􀤆" label="$iface"
        exit 0
    fi
done

SSID="$(ipconfig getsummary en0 | awk -F: '/^[[:space:]]*SSID/{print $2}' | xargs)"

if [[ -n "$SSID" ]]; then
    sketchybar --set "$NAME" icon="􀙇" label="$SSID"
else
    sketchybar --set "$NAME" icon="􁣡" label="-"
fi
