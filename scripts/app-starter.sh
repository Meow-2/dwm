#! /bin/sh
# 命令调用脚本

terminal() {
    case $1 in
        new) alacritty ;;
        temp) alacritty -t temp ;;
        ssh) alacritty -t ssh -e ~/Programs/dwm/scripts/set-lemonade.sh ;;
    esac
}

set_vol() {

    case $1 in
        up) /usr/bin/amixer -D pulse -qM set Master 3%+ umute \
            && cvlc --play-and-exit /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga ;;
        down) /usr/bin/amixer -D pulse -qM set Master 3%- umute \
            && cvlc --play-and-exit /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga ;;
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
    terminal) terminal $2 ;;
    killw) kill -9 $(xprop | grep "_NET_WM_PID(CARDINAL)" | awk '{print $3}') ;;
    filemanager) pcmanfm ;;
    blurlock) betterlockscreen --lock dim ;;
    chrome) google-chrome-stable --password-store=gnome ;;
    wechat) /opt/apps/com.qq.weixin.deepin/files/run.sh ;;
    qq) /opt/apps/com.qq.tim.spark/files/run.sh ;;
    # qq) icalingua ;;
    flameshot) flameshot gui ;;
    Telegram) telegram-desktop ;;
    wemeet) wemeet ;;
    steam) steam ;;
    obsidian) obsidian ;;
    changewallpaper) feh --randomize --bg-fill ~/Pictures/wallpapers/* ;;
    set_vol) set_vol $2 ;;
    set_backlight) set_backlight $2 ;;
esac
