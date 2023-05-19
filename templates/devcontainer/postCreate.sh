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

sudo apt update && sudo apt install -y python3-neovim

# should prepare ~/.profile ~/.bashrc ~/.zshrc, postCreate*.sh will modify them
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/ensonmj/dotfiles.git "$HOME/.dotfiles"
    source $HOME/.dotfiles/install.sh
fi

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/postCreateCpp.sh
source ${SCRIPT_DIR}/postCreateJava.sh
source ${SCRIPT_DIR}/postCreateWorkspace.sh
