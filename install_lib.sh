#!/bin/bash

DOTFILES_INSTALL_STATE_DIR="${DOTFILES_INSTALL_STATE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-install}"
mkdir -p "$DOTFILES_INSTALL_STATE_DIR"

require_cmd() {
	local missing=0
	local cmd
	for cmd in "$@"; do
		if ! command -v "$cmd" &>/dev/null; then
			echo "Missing required command: $cmd" >&2
			missing=1
		fi
	done
	return "$missing"
}

run_once() {
	local name="$*"
	local marker_name=${name//[^[:alnum:]_.=-]/_}
	local marker="$DOTFILES_INSTALL_STATE_DIR/$marker_name.done"

	if [[ -f "$marker" ]]; then
		echo "Skip $name"
		return 0
	fi

	echo "Run $name"
	"$@"
	touch "$marker"
}