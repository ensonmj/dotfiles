#!/bin/bash

if [ -n "$HTTP_PROXY" ]
then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
# cargo install sccache
cargo install fd-find
cargo install ripgrep
cargo install just

sudo apt update
sudo apt install -y stow
git clone https://github.com/ensonmj/dotfiles .dotfiles
pushd ~/.dotfiles
stow -S zsh
popd
sudo apt install -y zsh
