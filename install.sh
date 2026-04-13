#!/usr/bin/env zsh

if [[ ! -d ~/dotfiles ]]; then
    git clone https://github.com/willsawyerrrr/dotfiles.git ~/dotfiles
fi

if ! ( which brew >/dev/null ); then
    NONINTERACTIVE=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ ! -d $ZSH ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

brew bundle install

stow --dotfiles .
