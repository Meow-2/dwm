#!/bin/sh
# dwm状态栏刷新脚本

source ~/.profile

s2d_reset="^d^"
s2d_fg="^c"
s2d_bg="^b"
# color00="#2D1B46^"
# color01="#223344^"
# color02="#4E5173^"
# color03="#333344^"
# color04="#111199^"
# color05="#442266^"
# color06="#335566^"
# color07="#334466^"
# color08="#553388^"
# color09="#EEEEEE^"

# color00="#DFF6FF^"
# color00="#16213E^"
# color01="#FFD371^"
# color02="#FEB139^"
# color03="#F55353^"
# color04="#143F6B^"
#
# color05="#DFF6FF^" 
# color06="#16213E^"
# color07="#0F3460^"
# color08="#533483^"
# color09="#E94560^"

color00="#16213E^"
color01="#16213E^"
color02="#FCFFB2^"
color03="#B6E388^"
color04="#C7F2A4^"

color05="#DFF6FF^" 
color06="#FFD371^"
color07="#FEB139^"
color08="#E94560^"

others_color="$s2d_fg$color05$s2d_bg$color00"
net_color="$s2d_fg$color02$s2d_bg$color00"
cpu_color="$s2d_fg$color03$s2d_bg$color00"
mem_color="$s2d_fg$color04$s2d_bg$color00"
time_color="$s2d_fg$color05$s2d_bg$color00"
backlight_color="$s2d_fg$color06$s2d_bg$color00"
vol_color="$s2d_fg$color07$s2d_bg$color00"
bat_color="$s2d_fg$color08$s2d_bg$color00"

print_others() {
    icons=()
    # [ "$(pactl list sinks | awk 'BEGIN{RS=""};END{print NR}')" -gt 1 ] && icons=(${icons[@]} "")
    [ "$(pactl list sinks | grep Headphones)" ] && icons=(${icons[@]} "")
    [ "$(ps -aux | grep v2raya | sed 1d)" ] && icons=(${icons[@]} "")
    [ "$(ps -aux | grep 'arch')" ] && icons=(${icons[@]} "")
    # [ "$AUTOSCREEN" = "OFF" ] && icons=(${icons[@]} "ﴸ")
    # [ "$(ps -aux | grep 'danmu_sender' | sed 1d)" ] && icons=(${icons[@]} "ﳲ")

    if [ "$icons" ]; then
        text=" ${icons[@]} "
        color=$others_color
        printf "%s%s%s" "$color" "$text" "$s2d_reset"
    fi
}

print_net() {
    net_icon=""

    if [ $(echo $net_speed | grep "K" || echo $net_speed | grep "M") ]; then
        net_text=$(echo $net_speed | awk '{printf "%4s/s", $1}')
    else
        net_text=$(echo $net_speed | awk '{printf "%3sB/s", $1}')
    fi

    text=" $net_icon $net_text "
    color=$net_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_cpu() {
    cpu_icon="閭"
    cpu_text=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%02d%", 100 - $1}')

    text=" $cpu_icon $cpu_text "
    color=$cpu_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_mem() {
    mem_total=$(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}')
    mem_free=$(cat /proc/meminfo | grep "MemFree:" | awk '{print $2}')
    mem_buffers=$(cat /proc/meminfo | grep "Buffers:" | awk '{print $2}')
    mem_cached=$(cat /proc/meminfo | grep -w "Cached:" | awk '{print $2}')
    men_usage_rate=$(((mem_total - mem_free - mem_buffers - mem_cached) * 100 / mem_total))
    mem_icon=""
    mem_text=$(echo $men_usage_rate | awk '{printf "%02d%", $1}')
    text=" $mem_icon $mem_text "
    color=$mem_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_time() {
    time_text="$(date '+%m/%d %H:%M')"
    case "$(date '+%I')" in
        "01") time_icon="" ;;
        "02") time_icon="" ;;
        "03") time_icon="" ;;
        "04") time_icon="" ;;
        "05") time_icon="" ;;
        "06") time_icon="" ;;
        "07") time_icon="" ;;
        "08") time_icon="" ;;
        "09") time_icon="" ;;
        "10") time_icon="" ;;
        "11") time_icon="" ;;
        "12") time_icon="" ;;
    esac

    text=" $time_icon $time_text "
    color=$time_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_backlight() {
    backlight_text=$(xbacklight | awk '{printf "%02d%", $1}')
    backlight_icon="盛"
    backlight_text=$backlight_text

    [ "$(cat /etc/hostname)" = "Noatomusk" ] && backlight_text=90%

    text=" $backlight_icon $backlight_text "
    color=$backlight_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_vol() {
    vol_muted=$(amixer -D pulse get Master | tail -n1 | grep '\[off\]')
    vol_text=$(amixer -D pulse get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')
    if [ "$vol_muted" ]; then
        vol_text="--"
        vol_icon="婢"
    elif [ "$vol_text" -eq 0 ]; then
        vol_icon="婢"
    elif [ "$vol_text" -lt 10 ]; then
        vol_icon="奄"
        vol_text=0$vol_text
    elif [ "$vol_text" -le 20 ]; then
        vol_icon="奄"
    elif [ "$vol_text" -le 60 ]; then
        vol_icon="奔"
    else vol_icon="墳"; fi

    vol_text=$vol_text%

    text=" $vol_icon $vol_text "
    color=$vol_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_bat() {
    bat_text=$(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+")
    [ ! "$bat_text" ] && bat_text=$(acpi -b | sed 2d | awk '{print $5}' | grep -Eo "[0-9]+")
    bat_text=$bat_text%
    [ ! "$(acpi -b | grep 'Battery 0' | grep Discharging)" ] && charge_icon=""
    [ "$(acpi -b | grep 'Battery 0' | grep remaining)" ] && bat_text="$bat_text $(acpi -b | sed 2d | awk '{print $5}')"
    if [ "$bat_text" -ge 95 ]; then
        charge_icon=""
        bat_icon=""
    elif [ "$bat_text" -ge 90 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 80 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 70 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 60 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 50 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 40 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 30 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 20 ]; then
        bat_icon=""
    elif [ "$bat_text" -ge 10 ]; then
        bat_icon=""
    else bat_icon=""; fi

    if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
        charge_icon=""
        bat_icon=""
        bat_text=100%
    fi

    bat_icon=$charge_icon$bat_icon
    text=" $bat_icon $bat_text "
    color=$bat_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

xsetroot -name "$(print_others)$(print_net)$(print_cpu)$(print_mem)$(print_time)$(print_backlight)$(print_vol)$(print_bat)"
