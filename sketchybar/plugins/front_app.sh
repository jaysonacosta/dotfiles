#!/bin/bash
# shellcheck disable=SC1091
source "$HOME"/.config/sketchybar/plugins/icon_map.sh

if [ "$SENDER" = "front_app_switched" ]; then
	__icon_map "$INFO"

	# shellcheck disable=SC2154
	sketchybar --set "$NAME" label="$INFO" icon.font="sketchybar-app-font:regular:14" icon="$icon_result"
fi
