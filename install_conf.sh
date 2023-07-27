#!/bin/bash

# XDG - set defaults as they may not be set (eg Ubuntu 14.04 LTS)
# See https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
# and https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=$HOME/.cache}

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

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
	wezterm
)
for conf in "${confs[@]}"; do
	stow -S "$conf"
done
popd
# }}}

echo "Start to install some command line tools, $(date)"

if ! command -v cargo &>/dev/null; then
	export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
	export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y \
		--no-modify-path --default-toolchain stable --profile default
	if [ $? -ne 0 ]; then
		RED='\033[0;31m'
		NC='\033[0m' # No Color
		echo -e "${RED}Install rustup failed${NC}"
		exit 1
	fi
fi
source ~/.cargo/env
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
# cargo install cargo-binstall
# cargo install cargo-quickinstall
# https://gist.github.com/sts10/daadbc2f403bdffad1b6d33aff016c0a
declare -a bins=(
	fd-find
	git-delta
	ripgrep
	starship # need to config shell and install nerd fonts
	zoxide # need to config shell
)
cargo binstall --no-confirm --no-symlinks "${bins[@]}"

echo "All done, $(date)"

# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"