#!/usr/bin/env bash

xrandr --output eDP-1 --primary --mode 1920x1080 --rate 60.00 --pos 0x0 --rotate normal \
    --output HDMI-1 --off \
    --output Dp-0 --off \
    --output Dp-1 --off \
    --output Dp-2 --off \
    --output Dp-3 --off \
    --output Dp-4 --off \
    --output Dp-5 --off

"$HOME/.config/dwm/scripts/screen/common/Wallparper.sh"
