#!/usr/bin/env bash

xrandr --output eDP-1 --mode 1920x1080 --rate 60.00 --pos 1920x1080 --rotate normal \
    --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rate 60.00 --scale 1x1 --rotate normal \
    --output DP-1 --off \
    --output DP-2 --off \
    --output DP-3 --off \
    --output DP-4 --off

"$HOME/.config/dwm/scripts/screen/common/Wallparper.sh"
