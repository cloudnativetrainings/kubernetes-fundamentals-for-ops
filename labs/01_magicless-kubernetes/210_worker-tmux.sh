#!/bin/bash

### NOTE!!!
# on gcloud shell, disable tmux!!! 

set -euxo pipefail

source .trainingrc

tmux new-session -d -s magicless-worker
tmux split-window -t magicless-worker:0.0
tmux split-window -t magicless-worker:0.0
tmux select-layout -t magicless-worker:0 even-vertical

tmux send-keys -t magicless-worker:0.0 'docker exec -it worker-0 bash' C-m
tmux send-keys -t magicless-worker:0.1 'docker exec -it worker-1 bash' C-m
tmux send-keys -t magicless-worker:0.2 'docker exec -it worker-2 bash' C-m

tmux setw synchronize-panes on

tmux att -t magicless-worker
