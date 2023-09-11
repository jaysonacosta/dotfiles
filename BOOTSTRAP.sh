#!/bin/bash

# Clear the screen
echo -e '\033[2J\033[u'

echo "System to configure:"
echo "(1) Mac"
echo "(2) Linux"
echo "(q) Quit and do nothing"
echo

read -p "Choice: " system_choice

if [[ "$system_choice" != "1" && "$system_choice" != "2" ]]; then
    exit 0
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
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif [ "$system_choice" == "2" ]
then
    # Linux
    sudo apt update
    sudo apt upgrade
    sudo apt install curl
    echo "Installing zsh..."
    sudo apt install zsh
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Installing vim-plug..."
# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
