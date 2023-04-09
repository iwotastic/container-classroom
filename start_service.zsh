#!/bin/zsh

if tmux ls | grep bcthing; then
    tmux a -t bcthing
else
    # Clear log
    rm ./eclog.txt

    # Start the service
    tmux new-session -s "bcthing" "./ttyd -t disableLeaveAlert=true -t fontSize=14 -t \"titleFixed=Getting around Linux - VM\" -t \"theme={'background': 'black'}\" --ping-interval 10 ./new_ephemeral_container.zsh; zsh" \; \
        split-window -h "htop" \; \
        split-window -v
fi
