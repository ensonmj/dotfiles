#!/bin/bash
set -Eeuo pipefail

TARGET_PATH=${1:-"$HOME/.config/Code/User"}

CUR_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
REPO_DIR=$(cd "$CUR_DIR/../.." && pwd)
# shellcheck disable=SC1091
source "$REPO_DIR/install_lib.sh"
require_cmd code jq sed

# Get the options
# case $1 in
# linux)
# 	TARGET_PATH=$HOME/.vscode-server/data/Machine/
# 	;;
# wsl)
# 	#sudo apt install --no-install-recommends wslu
# 	#TARGET_PATH=$(wslpath "$(wslvar USERPROFILE)")/AppData/Roaming/Code/User
# 	Please use "install.bat from cmd.exe with administrator privileges"
# 	exit
# 	;;
# *)
# 	echo "Unknown option"
# 	echo "./install.sh linux|wsl"
# 	exit
# 	;;
# esac

function link() {
	local src=$1
	local target=$2
	local backup

	mkdir -p "$(dirname "$target")"
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

link "$CUR_DIR/settings.json" "$TARGET_PATH/settings.json"
link "$CUR_DIR/keybindings.json" "$TARGET_PATH/keybindings.json"

function trim_comment() {
	sed "s|[ \t]*//.*$||" "$1" | sed "/^$/d"
}
while IFS= read -r extension; do
	run_once code --install-extension "$extension"
done < <(jq -r '.recommendations[]' < <(trim_comment "$CUR_DIR/extensions.json"))
