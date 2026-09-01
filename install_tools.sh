#!/bin/bash
set -Eeuo pipefail

echo "Start to install some command line tools, $(date)"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=os_env.sh
source "$SCRIPT_DIR/os_env.sh"
# shellcheck source=install_lib.sh
source "$SCRIPT_DIR/install_lib.sh"

download_installer() {
	local url=$1
	local output=$2
	curl --proto '=https' --tlsv1.2 -fsSL --connect-timeout 15 --max-time 120 \
		--retry 3 --retry-all-errors "$url" -o "$output"
}

install_starship() {
	if command -v starship &>/dev/null; then
		return 0
	fi

	local installer
	installer=$(mktemp)
	download_installer https://starship.rs/install.sh "$installer"
	if ! sh "$installer" -y -f -b "$HOME/.local/bin"; then
		rm -f "$installer"
		return 1
	fi
	rm -f "$installer"
}

install_zoxide() {
	if command -v zoxide &>/dev/null; then
		return 0
	fi

	local installer
	installer=$(mktemp)
	download_installer https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh "$installer"
	if ! sh "$installer"; then
		rm -f "$installer"
		return 1
	fi
	rm -f "$installer"
}

install_mise() {
	if command -v mise &>/dev/null; then
		return 0
	fi

	local installer
	installer=$(mktemp)
	download_installer https://mise.run "$installer"
	if ! sh "$installer"; then
		rm -f "$installer"
		return 1
	fi
	rm -f "$installer"
}

install_rustup() {
	if command -v cargo &>/dev/null; then
		return 0
	fi

	export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
	export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y \
		--no-modify-path --default-toolchain stable --profile default
}

install_wezterm() {
	if command -v wezterm &>/dev/null; then
		return 0
	fi

	local ubuntu_version
	case "$VER" in
	22.04 | 24.04 | 26.04)
		ubuntu_version=$VER
		;;
	*)
		echo "No current WezTerm nightly .deb target for Ubuntu $VER" >&2
		return 1
		;;
	esac

	require_cmd sha256sum sudo

	local base_url=https://github.com/wezterm/wezterm/releases/download/nightly
	local deb_name="wezterm-nightly.Ubuntu${ubuntu_version}.deb"
	local tmp_dir deb_path sha_path expected_sha actual_sha
	tmp_dir=$(mktemp -d)
	deb_path="$tmp_dir/$deb_name"
	sha_path="$tmp_dir/$deb_name.sha256"

	download_installer "$base_url/$deb_name" "$deb_path"
	download_installer "$base_url/$deb_name.sha256" "$sha_path"
	expected_sha=$(sed -E 's/^sha256://; s/[[:space:]].*$//' "$sha_path")
	actual_sha=$(sha256sum "$deb_path" | awk '{print $1}')
	if [[ ! "$expected_sha" =~ ^[0-9a-fA-F]{64}$ || "$actual_sha" != "$expected_sha" ]]; then
		echo "WezTerm checksum verification failed" >&2
		rm -rf "$tmp_dir"
		return 1
	fi

	sudo apt install -y "$deb_path"
	rm -rf "$tmp_dir"

	local terminfo
	terminfo=$(mktemp)
	download_installer https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo "$terminfo"
	tic -x -o "$HOME/.terminfo" "$terminfo"
	rm -f "$terminfo"
}

# some tools will be installed in $HOME/.local/bin
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
require_cmd curl mktemp

# starship: need to config shell and install nerd fonts
run_once install_starship
# zoxide: cd, need to config shell
run_once install_zoxide
# mise: tools manager, need to config shell
run_once install_mise
run_once mise install
run_once mise run setup

# wezterm {{{
# case "$OS" in
# *Ubuntu*)
# 	run_once install_wezterm
# 	;;
# esac
# }}}

run_once install_rustup

# nix {{{
# https://thiscute.world/posts/nixos-and-flake-basics
# https://github.com/dustinlyons/nixos-config
# https://www.rectcircle.cn/posts/nix-1-package-manager
# sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install) --no-daemon --no-channel-add --no-modify-profile
# source ~/.nix-profile/etc/profile.d/nix.sh
# mkdir -p ~/.config/nix && echo 'substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/' > ~/.config/nix/nix.conf
# nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
# # nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
# nix-channel --update

# nix-env -iA nixpkgs.neovim nixpkgs.wezterm
# }}}

echo "All done, $(date)"

# vim: foldmethod=marker
