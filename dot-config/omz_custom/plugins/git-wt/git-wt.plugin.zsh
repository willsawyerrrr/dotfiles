# git-wt shell hook for zsh

# Override git command to cd after 'git wt <branch>'
git() {
    if [[ "$1" == "wt" ]]; then
        shift
        local nocd_mode=""
        local nocd_flag=false
        # Check wt.nocd config (supports: true, all, create, false)
        nocd_mode="$(command git config --get wt.nocd 2>/dev/null || true)"
        local existing_worktrees=""
        if [[ "$nocd_mode" == "create" ]]; then
            # Get existing worktree paths before running git wt
            existing_worktrees=$(command git worktree list --porcelain 2>/dev/null | grep '^worktree ' | cut -d' ' -f2- || true)
        fi
        local args=()
        for arg in "$@"; do
            if [[ "$arg" == "--nocd" || "$arg" == "--no-switch-directory" ]]; then
                nocd_flag=true
            fi
            args+=("$arg")
        done
        local result
        result=$(GIT_WT_SHELL_INTEGRATION=1 command git wt "${args[@]}")
        local exit_code=$?
        # Get the last line for cd target
        local last_line
        last_line=$(echo "$result" | tail -n 1)
        if [[ $exit_code -eq 0 && -d "$last_line" ]]; then
            # Print all lines except the last (intermediate paths)
            echo "$result" | sed '$d' | while IFS= read -r line; do
                [[ -n "$line" ]] && echo "$line"
            done
            # Determine whether to cd
            local should_cd=true
            if [[ "$nocd_flag" == "true" ]]; then
                # --nocd flag always prevents cd
                should_cd=false
            elif [[ "$nocd_mode" == "true" || "$nocd_mode" == "all" ]]; then
                # wt.nocd=true/all prevents cd for all operations
                should_cd=false
            elif [[ "$nocd_mode" == "create" ]]; then
                # wt.nocd=create only prevents cd for new worktrees
                if echo "$existing_worktrees" | grep -qxF "$last_line"; then
                    should_cd=true  # existing worktree, allow cd
                else
                    should_cd=false  # new worktree, prevent cd
                fi
            fi
            if [[ "$should_cd" == "true" ]]; then
                cd "$last_line"
            else
                echo "$last_line"
            fi
        else
            echo "$result"
            return $exit_code
        fi
    else
        command git "$@"
    fi
}

# git wt <branch> completion for zsh with descriptions
_git-wt() {
    local -a completions
    # Pass all previous arguments plus current word to __complete
    local args=("${words[@]:1}")
    while IFS=$'\t' read -r comp desc; do
        [[ "$comp" == :* ]] && continue
        if [[ -n "$desc" ]]; then
            completions+=("${comp}:${desc}")
        else
            completions+=("${comp}")
        fi
    done < <(command git-wt __complete "${args[@]}" 2>/dev/null)
    _describe 'git-wt' completions
}

# Hook into git completion for 'git wt'
_git-wt-wrapper() {
    if (( CURRENT == 2 )); then
        _git  # Let git handle subcommand completion
    elif [[ "${words[2]}" == "wt" ]]; then
        shift words
        (( CURRENT-- ))
        _git-wt
    else
        _git
    fi
}

# Register completions if compdef is available
if (( $+functions[compdef] )); then
    compdef _git-wt git-wt
    compdef _git-wt-wrapper git
fi
