#!/usr/bin/bash

# Install Oh My Bash
if [[ ! -d $OSH ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

# Clone dotfiles
if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/willsawyerrrr/dotfiles.git ~/dotfiles
fi

# Symbolically link config files
ln --force --symbolic ~/dotfiles/bash_aliases    ~/.bash_aliases
ln --force --symbolic ~/dotfiles/bash_env        ~/.bash_env
ln --force --symbolic ~/dotfiles/bashrc          ~/.bashrc
ln --force --symbolic ~/dotfiles/gh/config.yaml  ~/.config/gh/config.yml
ln --force --symbolic ~/dotfiles/ghci            ~/.ghci
ln --force --symbolic ~/dotfiles/gitconfig       ~/.gitconfig
ln --force --symbolic ~/dotfiles/hushlogin       ~/.hushlogin
ln --force --symbolic ~/dotfiles/osh_custom      ~/.oh-my-bash/custom
ln --force --symbolic ~/dotfiles/oshrc           ~/.oshrc
ln --force --symbolic ~/dotfiles/profile         ~/.profile
ln --force --symbolic ~/dotfiles/Rprofile        ~/.Rprofile
ln --force --symbolic ~/dotfiles/ssh/config      ~/.ssh/config
ln --force --symbolic ~/dotfiles/tmux.conf       ~/.tmux.conf
ln --force --symbolic ~/dotfiles/vimrc           ~/.vimrc
