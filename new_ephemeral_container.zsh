#!/bin/zsh

# Container setup config
imagename=bc23-base
username=ubuntu

# Resused escape codes
clrformat="\e[0m"

# Print banner
figlet -f slant "Welcome!" | lolcat

# Instantiate new ephermeral container and capture it's name
echo "\e[1mSetting up your workshop workspace...$clrformat (this may take a minute)"
contname=$(lxc launch $imagename -e | grep Starting | cut -f 2 -d " ")
lxc config set $contname limits.processes 256
lxc config set $contname limits.memory 512MiB
echo "launched $contname" >> ./eclog.txt

# Set up a trap, so that we always clean up like the good neighbors we are
function handle_hup() {
    echo "stopped $contname" >> ./eclog.txt
    lxc delete $contname -f
    exit 0
}
trap handle_hup EXIT

# Connect to the container
echo "\e[1m\e[92mDone setting up workspace!$clrformat"
echo "This is your very own Linux container in the cloud, made fresh just for you!"
echo "Keep in mind that your usage of this container will be monitored for security."
echo "This is a temporary container, so \e[1mall files will be erased when this tab is closed$clrformat."
echo ""

# This while loop allows for the possibility of doing things that require logging out
# and back in. If the user types exit, they will just be yeeted back into the
# container again.
while true; do
    lxc exec $contname -- su - $username
    echo "\e[2J\e[1;1H\e[1m"
    figlet -f small "A fresh start..."
    sleep 0.5
    echo "Logging you back in...$clrformat"
    sleep 0.5
    echo "If you actually want to leave, just close your browser tab or window."
    echo "When this tab is closed, this container will automatically get cleaned up." 
    echo ""
done
