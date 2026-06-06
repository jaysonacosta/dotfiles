#!/bin/bash

if [ "$SENDER" = "volume_change" ]; then
	VOLUME="$INFO"

	[[ "$VOLUME" -ne 0 ]] && ICON=􀊦 || ICON=􀊢

	sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
fi
