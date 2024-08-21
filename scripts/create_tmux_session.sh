#!/usr/bin/env bash

#need to add NVM env variables for the tmux session to see npm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

command="npm run dev -- --host=$3 --port=$4"

echo "Starting tmux server..."
echo "tmux -L frontforge new -s $1 -c $2 -d \"$command\""
tmux -L frontforge new -s $1 -c $2 -d "$command"
echo "Sessions started:"
tmux -L frontforge ls