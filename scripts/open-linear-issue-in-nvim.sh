#!/usr/bin/env zsh
#
# open-linear-issue-in-nvim.sh <issue-identifier> <branch-name>

issue="$1"
branch="$2"

kitty_pid=$(pgrep -n kitty) # -n: Newest

if [[ -z "${kitty_pid}" ]]; then
    open -gna kitty

    kitty_pid=$(pgrep -n kitty)
fi

kitty_socket="/tmp/kitty-${kitty_pid}.sock"

until [[ -S "${kitty_socket}" ]]; do sleep 0.05; done

kitty @ --to="unix:${kitty_socket}" launch --cwd="$PWD" --type=tab zsh -ic "nvim -c 'ResearchPlanImplement ${issue} ${branch}'; exec zsh -i"
