#!/bin/bash

# Define directories
TOP_DIR="/home/wneild5/Projects/cocktail-hub-backend"
BOTTOM_DIR="/home/wneild5/Projects/cocktail-hub-frontend"

# Start a new tmux session
tmux new-session -d -s cdev_session -c "$TOP_DIR"

# Split panes
tmux select-pane -t 0
tmux split-window -h -c "$TOP_DIR"
tmux select-pane -t 0
tmux split-window -v -c "$BOTTOM_DIR"
tmux select-pane -t 2
tmux split-window -v -c "$BOTTOM_DIR"

# Run commands
tmux send-keys -t 0 "docker compose down && docker compose up" Enter
tmux send-keys -t 1 "npm run dev" Enter
tmux send-keys -t 2 "air" Enter

# Attach the session
tmux select-pane -t 3
tmux attach-session -t cdev_session

