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

# Stop tmux session
tmux kill-session -t "contclassroom"

# Kill all the ephemeral containers
# Note: this will kill ALL ephemeral containers in LXD, so be careful.
for cont in $(lxc ls -f csv | grep "EPHEMERAL" | cut -f 1 -d ","); do
    echo "Stopping and deleting $cont..."
    lxc delete -f $cont
done
