#!/bin/bash

### NOTE!!!
# on gcloud shell, disable tmux!!! 

set -euxo pipefail

tmux new-session -d -s magicless-master
tmux split-window -t magicless-master:0.0
tmux split-window -t magicless-master:0.0
tmux select-layout -t magicless-master:0 even-vertical

tmux send-keys -t magicless-master:0.0 'docker exec -it master-0 bash' C-m
tmux send-keys -t magicless-master:0.1 'docker exec -it master-1 bash' C-m
tmux send-keys -t magicless-master:0.2 'docker exec -it master-2 bash' C-m

tmux setw synchronize-panes on

tmux att -t magicless-master
