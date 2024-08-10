#!/bin/sh
source ~/.config/zsh/env.zsh

if [ "$(cat /etc/hostname)" = "Noatomusk" ]; then
    lemonade server -allow 127.0.0.1 --log-level=4 &
    ssh -L 43969:127.0.0.1:43969 -R 2489:127.0.0.1:2489 -p 43968 zk@${HOME_IP}
else
    lemonade server -allow 127.0.0.1 --log-level=4 &
    ssh -L 43969:127.0.0.1:43969 -R 2489:127.0.0.1:2489 -p 43970 zk@${REMOTE_SSH_PORT_IP}
fi
