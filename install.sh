#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode

# XDG - set defaults as they may not be set (eg Ubuntu 14.04 LTS)
# See https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
# and https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=$HOME/.cache}

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
    dpkg -s stow &> /dev/null && sudo apt-get -y install stow ;;
  *Arch*)
    pacman -Q stow &> /dev/null || yes | sudo pacman -S stow ;;
esac

# Stow packages {{{
stow -v stow # Setup stow itself

# Install **ALL** configs except **templates**
# Assume that there are no newlines in directory names
# find -L . -maxdepth 1 -type d ! \( -name templates -o -name '.*' \) -print | sed 's/^.\///' | xargs -t -n1 -- stow -v --target="$HOME"

# Just install some configs
declare -a confs=(
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
# }}}

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
source ~/.cargo/env
# cargo install sccache
cargo install --locked bat
cargo install --locked bottom
cargo install --locked git-delta
cargo install --locked fd-find
cargo install --locked hyperfine
cargo install --locked just
cargo install --locked miniserve
cargo install --locked procs
cargo install --locked ripgrep
cargo install --locked starship # need to config shell and nerd fonts
cargo install --locked tokei
cargo install --locked zoxide # need to config shell

# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
