. "$HOME/.cargo/env"

# Standard Shell config
export EDITOR=nvim
export MANPAGER=nvim\ +Man!
export PATH=/Users/willsawyerrrr/.local/bin:${PATH}
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib:${DYLD_FALLBACK_LIBRARY_PATH}
export PYTHONDONTWRITEBYTECODE=1

for env_file in ${ZDOTDIR}/env/*; . "${env_file}"
