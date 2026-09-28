if [[ -n "${WSL_DISTRO_NAME}" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
	export SSH_AUTH_SOCK=""
	alias op="op.exe"
	alias ssh="ssh.exe"
	alias ssh-add="ssh-add.exe"
else
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
