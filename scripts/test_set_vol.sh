#!/bin/bash

set_vol() {
    case $1 in
        up)
            pulsemixer --change-volume +3
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 &
            mpv --no-video ~/.config/dwm/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
            ;;
        down)
            pulsemixer --change-volume -3
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 &
            mpv --no-video ~/.config/dwm/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
            ;;
        toggle)
            pulsemixer --toggle-mute
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 &
            ;;
    esac
}

set_vol up
