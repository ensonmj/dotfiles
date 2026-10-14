#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
REPO_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
WSL_CONFIG_DIR="$SCRIPT_DIR/wsl2"
# shellcheck disable=SC1091
source "$REPO_DIR/install_lib.sh"
require_cmd cmp powershell.exe wslpath

if ! grep -qi microsoft /proc/sys/kernel/osrelease; then
	echo "This installer must run inside WSL." >&2
	exit 1
fi

case "$REPO_DIR" in
/mnt/*)
	echo "Warning: keeping the repository in the WSL filesystem (for example, $HOME/.dotfiles) is recommended." >&2
	echo "Current physical path: $REPO_DIR" >&2
	;;
esac

WINDOWS_PROFILE=$(powershell.exe -NoLogo -NoProfile -Command '[Environment]::GetFolderPath("UserProfile")' | tr -d '\r')
WINDOWS_HOME=$(wslpath "$WINDOWS_PROFILE")

sync_bootstrap_file() {
	local src=$1
	local target=$2
	local backup

	if [[ -f "$target" ]] && cmp -s "$src" "$target"; then
		echo "Up to date: $target"
		return 0
	fi

	if [[ -e "$target" || -L "$target" ]]; then
		backup="$target.bak"
		if [[ -e "$backup" || -L "$backup" ]]; then
			backup="$target.bak.$(date +%Y%m%d%H%M%S)"
		fi
		mv "$target" "$backup"
		echo "Backed up: $backup"
	fi
	cp "$src" "$target"
	echo "Updated: $target"
}

# These files must be readable before WSL starts, so they cannot point back into
# the WSL filesystem. They are the only intentionally copied configuration.
sync_bootstrap_file "$WSL_CONFIG_DIR/.wslconfig" "$WINDOWS_HOME/.wslconfig"
sync_bootstrap_file "$WSL_CONFIG_DIR/ssh.bat" "$WINDOWS_HOME/ssh.bat"

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass \
	-File "$(wslpath -w "$SCRIPT_DIR/link-file.ps1")" \
	-Source "$(wslpath -w "$WSL_CONFIG_DIR/fix-wsl-dhcp.ps1")" \
	-Target "$WINDOWS_PROFILE\fix-wsl-dhcp.ps1"

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass \
	-File "$(wslpath -w "$SCRIPT_DIR/vscode/install.ps1")"