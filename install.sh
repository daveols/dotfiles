#!/bin/bash

# This script backs up old dotfiles then creates sym links to the files in this repo

dir=~/dotfiles
olddir=~/dotfiles_old
files=".bashrc .tmux.conf .vimrc .zshrc .gitconfig"

echo "Creating $olddir for backup of any existing dotfiles"
mkdir -p $olddir

cd $dir

for file in $files; do
    mv ~/$file $olddir
    ln -s $dir/$file ~/$file
done

# if using fish:
# mv ~/.config/fish/config.fish ~/dotfiles_old/
# ln -s $dir/config.fish ~/.config/fish/config.fish

mv ~/Library/Application\ Support/Code/User/settings.json ~/dotfiles_old/
ln -s $dir/settings.json ~/Library/Application\ Support/Code/User/settings.json

echo "Done"

source ~/.zshrc

#### manual steps

# install homebrew
# brew install yarn

# install zsh or fish

## fish
# brew install fish
# echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
# chsh -s /opt/homebrew/bin/fish
# curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
# omf install https://github.com/jhillyerd/plugin-git
# brew install starship

## Fonts
# https://www.nerdfonts.com/
# Enable font in terminal

## tmux
# brew install tmux
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux && prefix + I for plugins

## ?? git clone git@github.com:challenger-deep-theme/tmux.git ~/.tmux/plugins/challenger-deep
## ?? git clone git@github.com:dracula/tmux.git ~/.tmux/plugins/dracula

# brew install fzf
# $(brew --prefix)/opt/fzf/install

## Github
# ssh-keygen -t rsa -b 4096 -C "10344370+daveols@users.noreply.github.com"