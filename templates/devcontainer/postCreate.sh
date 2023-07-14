#!/bin/bash
set -x

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
export SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
export CONF_DIR=$(cd -- "$SCRIPT_DIR/conf" &> /dev/null && pwd )
export WORKSPACE_DIR=$(cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd )

# "docker run --hostname=dev" not add entry into /etc/hosts
echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts

if [ -d "$HOME/.host" ]; then
    # "ssh -X" change inode of ".Xauthority", so it can't keep sync with host, then authentication will faild
    # https://medium.com/@jonsbun/why-need-to-be-careful-when-mounting-single-files-into-a-docker-container-4f929340834
    [[ -f "$HOME/.Xauthority" ]] || ln -s "$HOME/.host/.Xauthority" "$HOME/.Xauthority"
fi
# hack X11 forwarding
echo "DISPLAY=$(hostname):10" >> ~/.env

if [ -n "$HTTP_PROXY" ]; then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

# "apt update" should ahead any "apt install" in other scripts
sudo apt update
# for perf tool
sudo apt install -y linux-tools-common linux-tools-generic linux-tools-`uname -r`
# nvim
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
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

# should prepare ~/.profile ~/.bashrc ~/.zshrc, postCreate*.sh will modify them
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/ensonmj/dotfiles.git "$HOME/.dotfiles"
    source $HOME/.dotfiles/install.sh
fi

function trim_comment() {
    sed "s|[ \t]*//.*$||" $1 | sed "/^$/d"
}
export -f trim_comment
function merge_json() {
    jq -s add <(trim_comment $1) <(trim_comment $2)
}
export -f merge_json
function merge_vsconf() {
    SRC=$1
    TARGET=$2
    mkdir -p ${TARGET}
    for SRC_PATH in $SRC
    do
        if test -f ${SRC_PATH}
        then
            FILE="$(basename -- ${SRC_PATH})"
            TARGET_PATH=${TARGET}/${FILE}
            if [[ -f ${TARGET_PATH} ]]
            then
                TMP=${TARGET_PATH}.tmp
                merge_json ${TARGET_PATH} ${SRC_PATH} > ${TMP}
                rm ${TARGET_PATH}
                mv ${TMP} ${TARGET_PATH}
            else
                trim_comment ${SRC_PATH} > ${TARGET_PATH}
            fi
        fi
    done
}
export -f merge_vsconf

# load language specific extension and config
# https://stackoverflow.com/questions/12916352/shell-script-read-missing-last-line
function env_load() {
    while read -r LINE || [ -n "$LINE" ]; do
        if [[ $LINE != '#'* ]] && [[ $LINE == *'='* ]]; then
            ENV_VAR=$(echo $LINE | sed -e 's/\r//g' -e "s/'/'\\\''/g")
            eval "export $ENV_VAR"
        fi
    done < $1
}
[[ -f ${WORKSPACE_DIR}/.devcontainer.conf ]] && env_load ${WORKSPACE_DIR}/.devcontainer.conf

# workspace common vscode conf
merge_vsconf "${CONF_DIR}/workspace/vscode/*" "${WORKSPACE_DIR}/.vscode"
[[ "$CPP" == "ON" ]] && source ${CONF_DIR}/cpp/config.sh
[[ "$JAVA" == "ON" ]] && source ${CONF_DIR}/java/config.sh
[[ "$PYTHON" == "ON" ]] && source ${CONF_DIR}/python/config.sh
# workspace other config
source ${CONF_DIR}/workspace/config.sh
