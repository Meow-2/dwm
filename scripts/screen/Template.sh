#!/usr/bin/env bash

xrandr --output eDP --primary --mode 1920x1080 --rate 60.00 --pos 0x0 --rotate normal \
    --output HDMI-A-0 --off \
    --output DisplayPort-0 --off \
    --output DisplayPort-1 --off \
    --output DisplayPort-2 --off \
    --output DisplayPort-3 --off \
    --output DisplayPort-4 --off \
    --output DisplayPort-5 --off

"$HOME/.config/dwm/scripts/screen/Wallparper.sh"
