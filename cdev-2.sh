#!/bin/bash

# Define directories
TOP_DIR="/home/wneild5/Projects/cocktail-hub-backend"
BOTTOM_DIR="/home/wneild5/Projects/cocktail-hub-frontend"

# Start a new tmux session
tmux new-session -d -s cdev_session -c "$TOP_DIR"
tmux split-window -v -c "$BOTTOM_DIR"

# Run commands
tmux send-keys -t 0 "docker compose down && docker compose up" Enter
tmux send-keys -t 1 "npm run dev" Enter

tmux attach-session -t cdev_session

