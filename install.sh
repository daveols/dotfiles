#!/bin/bash

# This script backs up old dotfiles then creates sym links to the files in this repo

dir=~/dotfiles
olddir=~/dotfiles_old
files=".bashrc .tmux.conf .vimrc .zshrc .nvmrc .gitconfig"

echo "Creating $olddir for backup of any existing dotfiles"
mkdir -p $olddir

cd $dir

for file in $files; do
    mv ~/$file $olddir
    ln -s $dir/$file ~/$file
done

mv ~/.config/fish/config.fish ~/dotfiles_old/
ln -s $dir/config.fish ~/.config/fish/config.fish

mv ~/Library/Application\ Support/Code/User/settings.json ~/dotfiles_old/
ln -s $dir/settings.json ~/Library/Application\ Support/Code/User/settings.json

echo "Done"

source ~/.bashrc

#### manual steps

# install homebrew
# brew install yarn
# brew install tmux
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux && prefix + I for plugins

# install zsh or fish

## fish
# omf install https://github.com/jhillyerd/plugin-git
# brew install starship

## ?? git clone git@github.com:challenger-deep-theme/tmux.git ~/.tmux/plugins/challenger-deep
## ?? git clone git@github.com:dracula/tmux.git ~/.tmux/plugins/dracula

# brew install fzf
# $(brew --prefix)/opt/fzf/install