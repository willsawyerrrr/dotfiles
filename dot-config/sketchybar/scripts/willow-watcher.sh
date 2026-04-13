#!/usr/bin/env zsh
#
# Watches Willow Voice os_log messages and fires sketchybar events when a
# dictation session starts or stops.

/usr/bin/env log stream \
	--predicate 'process == "Willow Voice" AND (eventMessage CONTAINS "Streaming session started successfully" OR eventMessage CONTAINS "Stopped audio capture")' \
	--level debug 2>/dev/null |
	while IFS= read -r line; do
		if [[ "$line" == *"Streaming session started successfully"* ]]; then
			sketchybar --trigger willow_start
		elif [[ "$line" == *"Stopped audio capture"* ]]; then
			sketchybar --trigger willow_stop
		fi
	done
