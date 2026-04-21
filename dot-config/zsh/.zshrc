export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dracula"
ZSH_CUSTOM="${XDG_CONFIG_HOME}/omz_custom"
ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

DISABLE_AUTO_TITLE="true"
HYPHEN_INSENSITIVE="false"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="%F{yellow}completing...%f"

plugins=(
	1password
	autoenv
	aws
	config
	docker
	fzf
	get-app-id
	git
	kubectl
	mongo-tunnel
	pipx
	poetry
	task
	terraform
	uv
)

source "${ZSH}/oh-my-zsh.sh"

# autoload -Uz edit-command-line
# zle -N edit-command-line
# bindkey '^Xe' edit-command-line

HISTFILE="${ZSH_CACHE_DIR}/history"
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_HISTORY       # Save timestamps
setopt HIST_IGNORE_ALL_DUPS   # Don't record duplicates
setopt HIST_IGNORE_SPACE      # Don't record commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove redundant spaces
setopt INC_APPEND_HISTORY     # Append to history file immediately
