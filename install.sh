#!/bin/bash

# set -euo pipefail; shopt -s failglob # safe mode
# -u : cause sdkman throw "unbound variable" error
# set -x

# XDG - set defaults as they may not be set (eg Ubuntu 14.04 LTS)
# See https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
# and https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=$HOME/.cache}

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/install_nerdfonts.sh

# Install stow (if not already installed)
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

case $OS in
  *Ubuntu*)
    dpkg -s stow &> /dev/null || sudo apt-get -y install stow ;;
  *Arch*)
    pacman -Q stow &> /dev/null || yes | sudo pacman -S stow ;;
esac

# Stow packages {{{
pushd $SCRIPT_DIR
# Install **ALL** configs except **templates**
# Assume that there are no newlines in directory names
# find -L . -maxdepth 1 -type d ! \( -name templates -o -name '.*' \) -print | sed 's/^.\///' | xargs -t -n1 -- stow -v --target="$HOME"

# backup
[[ -f ~/.profile ]] && mv ~/.profile{,.orig}
[[ -f ~/.bashrc ]] && mv ~/.bashrc{,.orig}
[[ -f ~/.bash_profile ]] && mv ~/.bash_profile{,.orig}
[[ -f ~/.zshrc ]] && mv ~/.zshrc{,.orig}
# Just install some configs
declare -a confs=(
    stow
    dircolors
    starship
    readline
    profile
    bash
    zsh
    vim
    nvim
    wezterm
)
for conf in "${confs[@]}"; do
    stow -S "$conf"
done
popd
# }}}

echo "Start to install some command line tools, $(date)"
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y \
    --no-modify-path --default-toolchain stable --profile default
fi
source ~/.cargo/env
# https://gist.github.com/sts10/daadbc2f403bdffad1b6d33aff016c0a
declare -a bins=(
    bandwhich
    bat
    bottom
    broot
    dufs
    du-dust
    erdtree
    fd-find
    git-delta
    gitui
    hyperfine
    just
    procs
    ripgrep
    # sccache # depends on pkg-config
    sd
    skim
    starship # need to config shell and install nerd fonts
    stylua
    tealdeer
    topgrade
    tokei
    xcp
    zoxide # need to config shell
)
# install in parallel and wait until finish
# https://klotzandrew.com/blog/parallel-bash-with-wait
declare -A status
for bin in "${bins[@]}"; do
    cargo install "$bin" &
    # pids+=($!)
    status["$bin"]=$!
done
for bin in "${!status[@]}"; do
    wait "${status[$bin]}"
    status["$bin"]=$?
done
for bin in "${!status[@]}"; do
    echo "install $bin exited with ${status[$bin]}"
done
echo "All done, $(date)"

# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
