#!/bin/bash
set -Eeuo pipefail

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=os_env.sh
source "$SCRIPT_DIR/os_env.sh"
# shellcheck source=install_lib.sh
source "$SCRIPT_DIR/install_lib.sh"

backup_file() {
	local path=$1
	local backup

	if [[ ! -f "$path" || -L "$path" ]]; then
		return 0
	fi

	backup="$path.orig"
	if [[ -e "$backup" ]]; then
		backup="$path.orig.$(date +%Y%m%d%H%M%S)"
	fi
	mv "$path" "$backup"
}

# config
case "$OS" in
*Ubuntu*)
	dpkg -s stow &>/dev/null || sudo apt-get -y install stow
	dpkg -s cmake &>/dev/null || sudo apt-get -y install cmake
	;;
*Arch*)
	pacman -Q stow &>/dev/null || sudo pacman -S --noconfirm stow
	pacman -Q cmake &>/dev/null || sudo pacman -S --noconfirm cmake
	;;
esac
require_cmd stow

# Stow packages {{{
pushd "$SCRIPT_DIR"
# Install **ALL** configs except **templates**
# Assume that there are no newlines in directory names
# find -L . -maxdepth 1 -type d ! \( -name templates -o -name '.*' \) -print | sed 's/^.\///' | xargs -t -n1 -- stow -v --target="$HOME"

# backup
backup_file "$HOME/.profile"
backup_file "$HOME/.bashrc"
backup_file "$HOME/.bash_profile"
backup_file "$HOME/.zshrc"

# will link some tools from scripts into $HOME/.local/bin
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# Just install some configs
declare -a confs=(
	bash
	git
	helix
	mise
	nvim
	profile
	scripts
	starship
	stow
	vim
	zellij
	zsh
)
for conf in "${confs[@]}"; do
	run_once stow -S "$conf"
done
popd
# }}}

# homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
