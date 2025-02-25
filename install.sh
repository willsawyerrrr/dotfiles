#!/usr/bin/env bash

# Install Oh My Bash
if [[ ! -d $OSH ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

# Clone dotfiles
if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/willsawyerrrr/dotfiles.git ~/dotfiles
fi

# Prepare dotfile directories
mkdir --parents ~/.config/gh ~/.config/i3 ~/.ssh ~/Pictures
rm --force --recursive ~/.oh-my-bash/custom

# Prepare secrets
if [[ ! -f ~/dotfiles/bash_secrets ]]; then
    cp ~/dotfiles/bash_secrets.example ~/dotfiles/bash_secrets
fi

# Symbolically link config files
ln --force --no-dereference --symbolic ~/dotfiles/background.jpg        ~/Pictures/background.jpg
ln --force --no-dereference --symbolic ~/dotfiles/background.png        ~/Pictures/background.png
ln --force --no-dereference --symbolic ~/dotfiles/bash_aliases          ~/.bash_aliases
ln --force --no-dereference --symbolic ~/dotfiles/bash_env              ~/.bash_env
ln --force --no-dereference --symbolic ~/dotfiles/bash_secrets          ~/.bash_secrets
ln --force --no-dereference --symbolic ~/dotfiles/bashrc                ~/.bashrc
ln --force --no-dereference --symbolic ~/dotfiles/gh_config.yaml        ~/.config/gh/config.yml
ln --force --no-dereference --symbolic ~/dotfiles/ghci                  ~/.ghci
ln --force --no-dereference --symbolic ~/dotfiles/gitconfig             ~/.gitconfig
ln --force --no-dereference --symbolic ~/dotfiles/gitconfig.situ        ~/.gitconfig.situ
ln --force --no-dereference --symbolic ~/dotfiles/gitconfig.university  ~/.gitconfig.university
ln --force --no-dereference --symbolic ~/dotfiles/git_signing_key.pub   ~/.ssh/git_signing_key.pub
ln --force --no-dereference --symbolic ~/dotfiles/hushlogin             ~/.hushlogin
ln --force --no-dereference --symbolic ~/dotfiles/i3_config             ~/.config/i3/config
ln --force --no-dereference --symbolic ~/dotfiles/osh_custom            ~/.oh-my-bash/custom
ln --force --no-dereference --symbolic ~/dotfiles/oshrc                 ~/.oshrc
ln --force --no-dereference --symbolic ~/dotfiles/profile               ~/.profile
ln --force --no-dereference --symbolic ~/dotfiles/Rprofile              ~/.Rprofile
ln --force --no-dereference --symbolic ~/dotfiles/ssh_allowed_signers   ~/.ssh/allowed_signers
ln --force --no-dereference --symbolic ~/dotfiles/ssh_config            ~/.ssh/config
ln --force --no-dereference --symbolic ~/dotfiles/tmux.conf             ~/.tmux.conf
ln --force --no-dereference --symbolic ~/dotfiles/vimrc                 ~/.vimrc
