#!/bin/bash
set -Eeuo pipefail

CUR_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
REPO_DIR=$(cd "$CUR_DIR/../.." && pwd)
# shellcheck disable=SC1091
source "$REPO_DIR/install_lib.sh"
require_cmd wslpath wslvar
# USR_DIR=$(cd ${CUR_DIR}/../../.. && pwd)
USR_DIR=$(wslpath "$(wslvar USERPROFILE)")

function link() {
	local src=$1
	local target=$2
	local backup

	if [[ -L "$target" && "$(readlink "$target")" == "$src" ]]; then
		return 0
	fi

	if [[ -e "$target" || -L "$target" ]]; then
		backup="$target.bak"
		if [[ -e "$backup" || -L "$backup" ]]; then
			backup="$target.bak.$(date +%Y%m%d%H%M%S)"
		fi
		mv "$target" "$backup"
	fi
	ln -s "$src" "$target"
	# cp ${SRC} ${TARGET}
}

# wsl2 config
cp "$CUR_DIR/.wslconfig" "$USR_DIR"
# use wsl2 ssh in windows cli
cp "$CUR_DIR/ssh.bat" "$USR_DIR"
# link dotfiles from windows to wsl2
link "$USR_DIR/.dotfiles" "$HOME/.dotfiles"
