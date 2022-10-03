#! /bin/bash
# DWM自启动脚本

settings() {
    [ $1 ] && sleep $1
    xset r rate 180 30
    setxkbmap -option caps:swapescape
    feh --bg-scale ~/Pictures/wallpapers/01.jpg
    ~/Programs/dwm/scripts/set-touchpad.sh
    xss-lock -- ~/scripts/app-starter.sh blurlock &
    # syndaemon -i 1 -t -K -R -d
}

daemons() {
    [ $1 ] && sleep $1
    fcitx5 &
    utools &
    # mailspring &
    # sleep 10 &
    # nm-applet &
    # pactl info &
    # flameshot &
    # xfce4-power-manager &
    # dunst -conf ~/scripts/config/dunst.conf &
    # lemonade server &
    # ~/scripts/app-starter.sh picom &
    # ~/scripts/app-starter.sh easyeffects &
}

every10s() {
    [ $1 ] && sleep $1
    while true; do
        # ~/scripts/set-screen.sh check &
        ~/Programs/dwm/scripts/dwm-status.sh &
        sleep 10
    done
}

settings 1 &
daemons 3 &
every10s 5 &
