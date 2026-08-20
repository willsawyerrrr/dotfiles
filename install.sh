#!/usr/bin/env zsh

if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/willsawyerrrr/dotfiles.git ~/dotfiles --recurse-submodules
fi

cd ~/dotfiles/

source ./dot-zshenv

if [[ ! -d $ZSH ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if ! ( which brew >/dev/null ); then
    NONINTERACTIVE=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! ( which cargo >/dev/null ); then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y
fi

brew bundle install --file ./dot-config/homebrew/Brewfile

task stow:install
task hooks:install
task macos:defaults
