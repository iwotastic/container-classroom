#!/bin/zsh
#  Copyright 2023 Ian Morrill
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# Container metadata
imagename="ubuntu:22.04"
username=ubuntu

# Resused escape codes
clrformat="\e[0m"

# Print welcome banner
figlet -f slant "Welcome!" | lolcat

# Instantiate new ephermeral container and capture it's name
echo "\e[1mSetting up your workshop workspace...$clrformat (this may take a minute)"
contname=$(lxc launch $imagename -e | grep Starting | cut -f 2 -d " ")

# Set process limit, this is critical for being on the open internet because
# it prevents users from forkbombing the host.
lxc config set $contname limits.processes 256

# This limit is less critical, but it just makes sure that container users
# can't do memory intensive things to DoS the host
lxc config set $contname limits.memory 512MiB

# Log creation
echo "launched $contname" >> ./eclog.txt

# Set up a trap, so that we always clean up like the good neighbors we are
function handle_hup() {
    # Log stop
    echo "stopped $contname" >> ./eclog.txt

    # Force delete the container
    lxc delete $contname -f

    # Actually exit
    exit 0
}
trap handle_hup EXIT

# Display informational MOTD.
echo "\e[1m\e[92mDone setting up workspace!$clrformat"
echo "This is your very own Linux container in the cloud, made fresh just for you!"
echo "Keep in mind that your usage of this container will be monitored for security."
echo "This is a temporary container, so \e[1mall files will be erased when this tab is closed$clrformat."
echo ""

# This while loop allows for the possibility of doing things that require logging out
# and back in. If the user types exit, they will just be yeeted back into the
# container again.
while true; do
    # Connect to the container as $username
    lxc exec $contname -- su - $username

    # Display informational banner
    echo "\e[2J\e[1;1H\e[1m"
    figlet -f small "A fresh start..."

    # The below sleeps prevent login loop-related glitches.
    # Also they look cool, so that's something.
    sleep 0.5
    echo "Logging you back in...$clrformat"
    sleep 0.5
    echo "If you actually want to leave, just close your browser tab or window."
    echo "When this tab is closed, this container will automatically get cleaned up."
    echo ""
done
