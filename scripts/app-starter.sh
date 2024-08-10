#!/bin/bash

terminal() {
    case $1 in
        temp) kitty --class floatkitty ;;
        current) kitty ;;
        btop)
            kitty -o initial_window_width=2560 -o initial_window_height=1440 -o remember_window_size=no --class=floatkitty -e btop
            ;;
        ssh) wezterm --config-file ~/.config/wezterm/wezterm_tmux.lua start -- ~/Programs/dwm/scripts/set-lemonade.sh ;;
    esac
}

# </dev/null >/dev/null 2>&1 &
# 丢弃所有的标准输入输出以及错误输出
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
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            mpv --no-video ~/.config/dwm/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
            ;;
        down)
            pactl set-sink-volume @DEFAULT_SINK@ -${step}% </dev/null >/dev/null 2>&1
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            # kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            mpv --no-video ~/.config/dwm/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
            ;;
        toggle)
            pactl set-sink-mute @DEFAULT_SINK@ toggle </dev/null >/dev/null 2>&1
            kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            ;;
    esac
}

set_backlight() {
    step=${2:-10}
    # if [ "$(cat /etc/hostname)" = "ThinkBook" ]; then
    case $1 in
        up)
            /usr/bin/light -A "${step}" </dev/null >/dev/null 2>&1
            kill -39 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            ;;
        down)
            /usr/bin/light -U "${step}" >/dev/null
            kill -39 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1
            ;;
    esac
    # elif [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
    #     current_backlight=$(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//')
    #     case $1 in
    #         up)
    #             /usr/bin/ddcutil setvcp 10 $((current_backlight + "${step}")) && kill -39 "$(pidof dwmblocks)"
    #             ;;
    #         down)
    #             /usr/bin/ddcutil setvcp 10 $((current_backlight - "${step}")) && kill -39 "$(pidof dwmblocks)"
    #             ;;
    #     esac
    #     ~/Programs/dwm/scripts/set-profile.sh backlight $(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//')
    # else
    #     case $1 in
    #         up) /usr/bin/xbacklight "+${step}" && kill -39 "$(pidof dwmblocks)" ;;
    #         down) /usr/bin/xbacklight "-${step}" && kill -39 "$(pidof dwmblocks)" ;;
    #     esac
    # fi
    # ~/Programs/dwm/scripts/dwm-status.sh
}

get_window_info() {
    window_info=$(xprop | awk -F'[=,]' '
        /^WM_NAME/ {
            gsub(/^ */, "", $2);
            title=$2;
        }
        /^WM_CLASS/ {
            gsub(/^ */, "", $3)
            gsub(/^ */, "", $2)
            class=$3
            instance=$2
        }
        END {
            printf("{%s,  %s,  %s,  0,  1,  0,  0,  -1,  0 },", class, instance, title)
        }')
    echo -n $window_info | xclip -selection c
    # 这里class要从$2开始赋值
    # 使用-F指定了分隔符，是为了保证空格不会被分隔，并且按'{'和','分隔
    # 又因为'{'在最前面，所以$1被赋值成了'{'之前的内容，'{'之前没有内容，$1就变成了空格
    display_info=$(
        echo -n $window_info | awk -F'[{,]' '
        {
            gsub(/^ */, "", $3)
            gsub(/^ */, "", $4)
            class=$2
            instance=$3
            title=$4
        } END {
            printf("class:%s, instance:%s, title:%s", class, instance, title)
        }'
    )
    dunstify "$display_info"
}

case $1 in
    set_vol) set_vol $2 $3 && kill -40 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 && exit 0 ;;
    set_backlight) set_backlight $2 $3 && kill -39 "$(pidof dwmblocks)" </dev/null >/dev/null 2>&1 && exit 0 ;;
    terminal) terminal $2 ;;
    killw) kill -9 $(xprop | grep "_NET_WM_PID(CARDINAL)" | awk '{print $3}') ;;
    getinfo) get_window_info ;;
    filemanager) nautilus -w ;;
    blurlock) betterlockscreen --lock dim ;;
    browser) microsoft-edge-dev --password-store=gnome ;;
    wechat) wechat-universal ;;
    qq) linuxqq ;;
    Telegram) telegram-desktop ;;
    clipboard) diodon ;;
    wemeet) wemeet ;;
    steam) steam ;;
    obsidian) obsidian ;;
    changewallpaper)
        killall mpv >>/dev/null 2>&1
        killall xwinwrap >>/dev/null 2>&1
        ~/Programs/dwm/scripts/set-profile.sh WALLPAPER_MODE "PIC"
        feh --randomize --bg-fill ~/Pictures/wallpapers/*.jpg
        ;;
    changevideo)
        killall mpv >>/dev/null 2>&1
        killall xwinwrap >>/dev/null 2>&1
        sleep 0.2
        ~/Programs/dwm/scripts/set-profile.sh WALLPAPER_MODE "VIDEO"
        mp4="~/Pictures/wallpapers/video/"$(ls ~/Pictures/wallpapers/video/ | sort -R | head -n1)
        eval xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --stop-screensaver=no --panscan=1.0 $mp4 >>/dev/null 2>&1 &
        echo -e "#!/bin/sh\neval xwinwrap -fs -nf -ov -- mpv -wid WID --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet --stop-screensaver=no --panscan=1.0 $mp4 >>/dev/null 2>&1 &" >~/.xwinwrap &
        ;;
esac
