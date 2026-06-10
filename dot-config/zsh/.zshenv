. "$HOME/.cargo/env"

# Standard Shell config
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export PATH="/Users/willsawyerrrr/.local/bin:${PATH}"

export LOCAL_ENV=1

export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/lib:${DYLD_FALLBACK_LIBRARY_PATH}"
export HOMEBREW_NO_ENV_HINTS=1
export PYTHONDONTWRITEBYTECODE=1

for env_file in ${ZDOTDIR}/env/*; . "${env_file}"
