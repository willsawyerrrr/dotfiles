. "$HOME/.cargo/env"

# Standard Shell config
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export PATH="/Users/willsawyerrrr/.local/bin:${PATH}"

export LOCAL_ENV=1

export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME}/claude/"
export DOTFILES_DIR="${HOME}/dotfiles"
export HOMEBREW_NO_ENV_HINTS=1
export LG_CONFIG_FILE="${XDG_CONFIG_HOME}/lazygit/config.yaml,${XDG_CONFIG_HOME}/lazygit/dracula.yaml"

export PYTHONDONTWRITEBYTECODE=1
export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:${DYLD_FALLBACK_LIBRARY_PATH}"

for env_file in ${ZDOTDIR}/env/*; . "${env_file}"
