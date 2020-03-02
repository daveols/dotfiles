#!/bin/bash
# This backs up old dotfiles then adds sym links for those in ~/dotfiles mentioned here

dir=~/dotfiles
olddir=~/dotfiles_old
files=".bashrc .tmux.conf .vimrc .zshrc .nvmrc .gitconfig"

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

#### manual steps
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/dracula/zsh.git $ZSH_CUSTOM/themes/dracula
# ln -s $ZSH_CUSTOM/themes/dracula/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
# brew install yarn
# brew install tmux
# git clone https://github.com/dracula/zsh.git $ZSH_CUSTOM/themes/dracula
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# git clone git@github.com:challenger-deep-theme/tmux.git ~/.tmux/plugins/challenger-deep
# brew install fzf
# $(brew --prefix)/opt/fzf/install

echo "Done"

source ~/.bashrc
