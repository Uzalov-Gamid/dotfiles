#!/usr/bin/env bash

DESIRED_SPACES=("main" "sec" "brwse" "note" "chat" "ai")

CURRENT_COUNT=$(yabai -m query --spaces | jq '. | length')
NEEDED_COUNT=${#DESIRED_SPACES[@]}

if [ "$CURRENT_COUNT" -lt "$NEEDED_COUNT" ]; then
    for ((i = CURRENT_COUNT; i < NEEDED_COUNT; i++)); do
        yabai -m space --create
    done
fi

index=1
for label in "${DESIRED_SPACES[@]}"; do
    yabai -m space $index --label "$label"
    ((index++))
done

sketchybar --trigger yabai_refresh 2>/dev/null || true
