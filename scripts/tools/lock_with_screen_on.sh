#!/bin/bash

# 锁屏但不关闭屏幕，在远程机器上运行此脚本后屏幕不会关闭，通过ToDesk连接远程机器的流畅性会好很多
xset s off -dpms &
while :; do
    idle_time=$(xprintidle)
    # 5min
    if [ $idle_time -gt 300000 ]; then
        betterlockscreen -l dim
    fi
done
