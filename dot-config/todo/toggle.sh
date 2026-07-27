#!/usr/bin/env bash
# Toggle a small kitty quick-access-terminal window with today's todo list.
# Bound to option+t (alt-t) in AeroSpace.
set -uo pipefail

TODO_FILE="$HOME/.config/todo/todo.md"

mkdir -p "$(dirname "$TODO_FILE")"
touch "$TODO_FILE"

heading="# $(date +%Y-%m-%d)"
if ! grep -qF "$heading" "$TODO_FILE"; then
  { printf '%s\n\n' "$heading"; cat "$TODO_FILE"; } >"$TODO_FILE.tmp"
  mv "$TODO_FILE.tmp" "$TODO_FILE"
fi

exec kitten quick-access-terminal \
  --instance-group todo \
  --config ~/.config/kitty/todo-quick-access.conf \
  env NVIM_APPNAME=todo-nvim nvim "$TODO_FILE"
