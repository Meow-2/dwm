#!/bin/bash

set_vol() {
    step=${2:-10}
    case $1 in
        up)
            current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | rg -o ' [0-9]+% ' | sed 's/%[[:space:]]//g' | head -n1)
            if [ $((current_volume + step)) -gt 100 ]; then
                pactl set-sink-volume @DEFAULT_SINK@ 100% </dev/null >/dev/null 2>&1
            else
                pactl set-sink-volume @DEFAULT_SINK@ +${step}% </dev/null >/dev/null 2>&1
            fi
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 &
            mpv --no-video ~/.config/dwm/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
            ;;
        down)
            pactl set-sink-volume @DEFAULT_SINK@ -${step}% </dev/null >/dev/null 2>&1
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 &
            # kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            mpv --no-video ~/.config/dwm/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
            ;;
        toggle)
            pactl set-sink-mute @DEFAULT_SINK@ toggle </dev/null >/dev/null 2>&1
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 &
            ;;
    esac
}

set_vol up 10
