#!/bin/bash
set -x

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
export SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
export CONF_DIR=$(cd -- "$SCRIPT_DIR/conf" &> /dev/null && pwd )
export WORKSPACE_DIR=$(cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd )

source ${SCRIPT_DIR}/helper.sh

# "docker run --hostname=dev" not add entry into /etc/hosts
echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts

if [ -d "$HOME/.host" ]; then
    # "ssh -X" change inode of ".Xauthority", so it can't keep sync with host, then authentication will faild
    # https://medium.com/@jonsbun/why-need-to-be-careful-when-mounting-single-files-into-a-docker-container-4f929340834
    safe_link ${HOME}/.host/.Xauthority ${HOME}/.Xauthority
fi
# hack X11 forwarding
echo "DISPLAY=$(hostname):10" >> ~/.env

if [ -n "$HTTP_PROXY" ]; then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

# "apt update" should ahead any "apt install" in other scripts
sudo apt update
# for perf tool, `uname -r` not work when host is not ubuntu
sudo apt install -y linux-tools-common linux-tools-generic #linux-tools-`uname -r`
# nvim
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
mkdir -p $HOME/.opt
tar -xf nvim-linux64.tar.gz -C $HOME/.opt
rm -f nvim-linux64.tar.gz
sudo apt install -y python3-neovim
# wezterm
# curl -LO https://github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu20.04.deb
# sudo apt install -y ./wezterm-20230408-112425-69ae8472.Ubuntu20.04.deb
# rm -f ./wezterm-20230408-112425-69ae8472.Ubuntu20.04.deb

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

# should prepare ~/.profile ~/.bashrc ~/.zshrc, install_vsconf will modify them
if [ ! -d "${HOME}/.dotfiles" ]; then
    git clone https://github.com/ensonmj/dotfiles.git "${HOME}/.dotfiles"
fi
bash ${HOME}/.dotfiles/install_conf.sh

# workspace common vscode conf
install_vsconf ${CONF_DIR}/workspace ${WORKSPACE_DIR}

# program language specific conf
while read -r LINE || [ -n "$LINE" ]; do
    if [[ $LINE != '#'* ]] && [[ $LINE == *'='* ]]; then
        LANG=$(echo $LINE | sed -e 's/\r//g' -e "s/'/'\\\''/g" | awk -F"=" '{print tolower($1)}')

        install_vsconf ${CONF_DIR}/${LANG} ${WORKSPACE_DIR}
    fi
done < ${WORKSPACE_DIR}/.devcontainer.conf

bash ${HOME}/.dotfiles/install_nerdfonts.sh
bash ${HOME}/.dotfiles/install_tools.sh
