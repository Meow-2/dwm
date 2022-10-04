#! /bin/sh
# DWM自启动脚本

settings() {
    [ $1 ] && sleep $1
    xset r rate 180 30 &
    setxkbmap -option caps:swapescape &
    ~/Programs/dwm/scripts/set-touchpad.sh &
    feh --bg-scale ~/Pictures/wallpapers/01.jpg &
}

daemons() {
    [ $1 ] && sleep $1
    redshift &
    fcitx5 &
    mailspring -b &
    utools &
    dunst -conf ~/Programs/dwm/scripts/conf/dunst.conf &
    blueman-applet &
    nm-applet &
    # xfce4-power-manager &
    # pactl info &
    # flameshot &
    # lemonade server &
    # ~/scripts/app-starter.sh picom &
    # ~/scripts/app-starter.sh easyeffects &
}

every1s() {
    [ $1 ] && sleep $1
    while true; do
        ~/Programs/dwm/scripts/cal-netspeed.sh
        ~/Programs/dwm/scripts/dwm-status.sh &
        sleep 1
    done
}

settings 1 &
daemons 3 &
every1s 1 &
