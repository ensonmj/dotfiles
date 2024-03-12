#!/bin/bash

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source $SCRIPT_DIR/os_env.sh

# config
case $OS in
*Ubuntu*)
	dpkg -s stow &>/dev/null || sudo apt-get -y install stow
	dpkg -s cmake &>/dev/null || sudo apt-get -y install cmake
	;;
*Arch*)
	pacman -Q stow &>/dev/null || yes | sudo pacman -S stow
	pacman -Q cmake &>/dev/null || yes | sudo pacman -S cmake
	;;
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
	helix
	wezterm
	git
)
for conf in "${confs[@]}"; do
	stow -S "$conf"
done
popd
# }}}

# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
