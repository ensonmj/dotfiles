#!/bin/bash

# "docker run --hostname=dev" not add entry into /etc/hosts
echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
# if kernel.yama.ptrace_scope in /etc/sysctl.d/10-ptrace.conf not set to 0
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

if [ -d "$HOME/.host" ]; then
    # "ssh -X" change inode of ".Xauthority", so it can't keep sync with host, then authentication will faild
    # https://medium.com/@jonsbun/why-need-to-be-careful-when-mounting-single-files-into-a-docker-container-4f929340834
    [[ -f "$HOME/.Xauthority" ]] || ln -s "$HOME/.host/.Xauthority" "$HOME/.Xauthority"
fi

if [ -n "$HTTP_PROXY" ]; then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

# "apt update" should ahead any "apt install" in other scripts
# for perf tool
sudo apt update && sudo apt install -y linux-tools-common linux-tools-generic linux-tools-`uname -r`

# should prepare ~/.profile ~/.bashrc ~/.zshrc, postCreate*.sh will modify them
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/ensonmj/dotfiles.git "$HOME/.dotfiles"
    source $HOME/.dotfiles/install.sh
fi
# hack X11 forwarding
echo "DISPLAY=$(hostname):10" >> ~/.env

# nix {{{
# https://thiscute.world/posts/nixos-and-flake-basics
# https://github.com/dustinlyons/nixos-config
# https://www.rectcircle.cn/posts/nix-1-package-manager
# sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install) --no-daemon --no-channel-add --no-modify-profile
# source ~/.nix-profile/etc/profile.d/nix.sh
# mkdir -p ~/.config/nix && echo 'substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/' > ~/.config/nix/nix.conf
# nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
# # nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
# nix-channel --update

# nix-env -iA nixpkgs.neovim nixpkgs.wezterm
# }}}

# nvim
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar -xf nvim-linux64.tar.gz -C $HOME/.opt
rm -f nvim-linux64.tar.gz
sudo apt install -y python3-neovim

# wezterm
# curl -LO https://github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu20.04.deb
# sudo apt install -y ./wezterm-20230408-112425-69ae8472.Ubuntu20.04.deb
# rm -f ./wezterm-20230408-112425-69ae8472.Ubuntu20.04.deb

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
[[ -f ${SCRIPT_DIR}/postCreateCpp.sh ]] && source ${SCRIPT_DIR}/postCreateCpp.sh
[[ -f ${SCRIPT_DIR}/postCreateJava.sh ]] && source ${SCRIPT_DIR}/postCreateJava.sh
[[ -f ${SCRIPT_DIR}/postCreateWorkspace.sh ]] && source ${SCRIPT_DIR}/postCreateWorkspace.sh
