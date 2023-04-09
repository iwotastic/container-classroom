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

if tmux ls | grep contclassroom; then
    tmux a -t contclassroom
else
    # Clear log
    rm ./eclog.txt

    # Start the service
    tmux new-session -s "contclassroom" "./ttyd -t disableLeaveAlert=true -t fontSize=14 -t \"titleFixed=Getting around Linux - VM\" -t \"theme={'background': 'black'}\" --ping-interval 10 ./new_ephemeral_container.zsh; zsh" \; \
        split-window -h "htop" \; \
        split-window -v
fi
