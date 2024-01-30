#!/usr/bin/env bash

# Install Oh My Bash
if [[ ! -d $OSH ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

# Clone dotfiles
if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/willsawyerrrr/dotfiles.git ~/dotfiles
fi

# Create config directories
mkdir --parents ~/.config/gh

# Symbolically link config files
ln --force --no-dereference --symbolic ~/dotfiles/bash_aliases    ~/.bash_aliases
ln --force --no-dereference --symbolic ~/dotfiles/bash_env        ~/.bash_env
ln --force --no-dereference --symbolic ~/dotfiles/bashrc          ~/.bashrc
ln --force --no-dereference --symbolic ~/dotfiles/gh_config.yaml  ~/.config/gh/config.yml
ln --force --no-dereference --symbolic ~/dotfiles/ghci            ~/.ghci
ln --force --no-dereference --symbolic ~/dotfiles/gitconfig       ~/.gitconfig
ln --force --no-dereference --symbolic ~/dotfiles/hushlogin       ~/.hushlogin
ln --force --no-dereference --symbolic ~/dotfiles/osh_custom      ~/.oh-my-bash/custom
ln --force --no-dereference --symbolic ~/dotfiles/oshrc           ~/.oshrc
ln --force --no-dereference --symbolic ~/dotfiles/profile         ~/.profile
ln --force --no-dereference --symbolic ~/dotfiles/Rprofile        ~/.Rprofile
ln --force --no-dereference --symbolic ~/dotfiles/ssh_config      ~/.ssh/config
ln --force --no-dereference --symbolic ~/dotfiles/tmux.conf       ~/.tmux.conf
ln --force --no-dereference --symbolic ~/dotfiles/vimrc           ~/.vimrc
