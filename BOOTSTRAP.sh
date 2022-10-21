#!/bin/bash

# Clear the screen
echo -e '\033[2J\033[u'

echo -e "\033[0;34m______             _       _                   "
echo -e "\033[0;34m| ___ \           | |     | |                  "
echo -e "\033[0;34m| |_/ / ___   ___ | |_ ___| |_ _ __ __ _ _ __  "
echo -e "\033[0;34m| ___ \/ _ \ / _ \| __/ __| __| '__/ _\` | '_ \ "
echo -e "\033[0;34m| |_/ / (_) | (_) | |_\__ \ |_| | | (_| | |_) |"
echo -e "\033[0;34m\____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/ "
echo -e "\033[0;34m                                        | |    "
echo -e "\033[0;34m                                        |_|    "

echo "System to configure:"
echo "(1)  Mac"
echo "(2)  Linux"
echo "(q) Quit and do nothing"
echo

read -p "Choice: " system_choice

if [ "$system_choice" == "q" ]
then
    exit 1
fi

# Create symlinks
echo "Creating symlinks..."
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vimrc ~/.vimrc

if [ "$system_choice" == "1" ]
then
    # Mac
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew bundle --file ~/.dotfiles/Brewfile
elif [ "$system_choice" == "2" ]
then
    # Linux
    echo "Instaling fish..."
    sudo apt update
    sudo apt upgrade
    sudo apt install curl
    sudo apt-add-repository ppa:fish-shell/release-3
    sudo apt update
    sudo apt install fish
fi

echo "Installing Fisher..."
# Fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

echo "Installing vim-plug..."
# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
