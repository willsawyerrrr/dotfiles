# Do nothing if op is not installed
(( ${+commands[op]} )) || return

# Generate the completion only when it is missing. Running `op` on every shell
# startup makes it probe the 1Password app's container, which macOS gates behind
# an "access data from other apps" prompt attributed to whichever app spawned
# the shell.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_op" ]]; then
  typeset -g -A _comps
  autoload -Uz _op
  _comps[op]=_op

  op completion zsh >| "$ZSH_CACHE_DIR/completions/_op" &|
fi

# Load opswd function
autoload -Uz opswd
