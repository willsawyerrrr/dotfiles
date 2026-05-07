#!/usr/bin/env zsh
#
# open-linear-issue-in-nvim.sh <issue-identifier> <branch-name>

issue="$1"
branch="$2"

git switch -c ${branch} origin/main

nvim .
