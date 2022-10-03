#! /bin/bash
# 命令调用脚本

blurlock() {
    i3lock \
        --blur 5 \
        --bar-indicator \
        --bar-pos y+h \
        --bar-direction 1 \
        --bar-max-height 50 \
        --bar-base-width 50 \
        --bar-color 00000022 \
        --keyhl-color ffffffcc \
        --bar-periodic-step 50 \
        --bar-step 20 \
        --redraw-thread \
        --clock \
        --force-clock \
        --time-pos x+5:y+h-80 \
        --time-color ffffffff \
        --date-pos tx:ty+15 \
        --date-color ffffffff \
        --date-align 1 \
        --time-align 1 \
        --ringver-color ffffff00 \
        --ringwrong-color ffffff88 \
        --status-pos x+5:y+h-16 \
        --verif-align 1 \
        --wrong-align 1 \
        --verif-color ffffffff \
        --wrong-color ffffffff \
        --modif-pos -50:-50
    xdotool mousemove_relative 1 1 # 该命令用于解决自动锁屏后未展示锁屏界面的问题(移动一下鼠标)
}

set_vol() {

    case $1 in
        up) /usr/bin/amixer -D pulse -qM set Master 5%+ umute ;;
        down) /usr/bin/amixer -D pulse -qM set Master 5%- umute ;;
        toggle) amixer -D pulse set Master 1+ toggle ;;
    esac
    ~/Programs/dwm/scripts/dwm-status.sh
}

set_backlight() {
    case $1 in
        up) /usr/bin/xbacklight +5 ;;
        down) /usr/bin/xbacklight -5 ;;
    esac
    ~/Programs/dwm/scripts/dwm-status.sh
}

case $1 in
    alacritty) alacritty ;;
    killw) kill -9 $(xprop | grep "_NET_WM_PID(CARDINAL)" | awk '{print $3}') ;;
    filemanager) dolphin ;;
    blurlock) blurlock ;;
    chrome) google-chrome-stable ;;
    flameshot) flameshot gui -c -p ~/Pictures/screenshots ;;
    set_vol) set_vol $2 ;;
    set_backlight) set_backlight $2 ;;
esac
