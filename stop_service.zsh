#!/bin/zsh

# Stop tmux session
tmux kill-session -t "bcthing"

# Kill all the ephemeral containers
for cont in $(lxc ls -f csv | grep "EPHEMERAL" | cut -f 1 -d ","); do
    echo "Stopping and deleting $cont..."
    lxc delete -f $cont
done
