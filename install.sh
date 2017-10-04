#!/bin/bash
# This backs up old dotfiles then adds sym links for those in ~/dotfiles mentioned here

dir=~/dotfiles
olddir=~/dotfiles_old
files=".bashrc .tmux.conf .vimrc .zshrc"

##########

# create dotfiles_old in ~
echo "Creating $olddir for backup of any existing dotfiles"
mkdir -p $olddir

cd $dir

# move old file then link new one
for file in $files; do
    echo "Moving existing $file to $olddir"
    mv ~/$file ~/dotfiles_old/
    echo "Creating symlink to $file in ~"
    ln -s $dir/$file ~/$file
done

# download plugins

git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "Done"

source ~/.bashrc
