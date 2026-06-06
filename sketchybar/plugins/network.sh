#!/bin/bash

VPN_CONNECTED=$(scutil --nc list | grep "Connected")

for iface in $(networksetup -listallhardwareports | awk '/Hardware Port:/ && !/Wi-Fi/{getline; print $2}'); do
	if ipconfig getifaddr "$iface" &>/dev/null; then
		[[ $VPN_CONNECTED ]] && ICON="􁅏" || ICON="􀤆"

		sketchybar --set "$NAME" icon="$ICON" label="$iface"
		exit 0
	fi
done

SSID="$(ipconfig getsummary en0 | awk -F: '/^[[:space:]]*SSID/{print $2}' | xargs)"

[[ $VPN_CONNECTED ]] && ICON="􁅏" || ICON="􀙇"

if [[ -n "$SSID" ]]; then
	sketchybar --set "$NAME" icon="$ICON" label="$SSID"
else
	sketchybar --set "$NAME" icon="􁣡" label="-"
fi
