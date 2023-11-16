#!/bin/bash

echo "Start to install some command line tools, $(date)"

mkdir -p $HOME/.opt
mkdir -p $HOME/.local/bin

# helix {{{
HX_VER="23.10"
HX_TAR="helix-${HX_VER}-x86_64-linux.tar.xz"
wget "https://github.com/helix-editor/helix/releases/download/${HX_VER}/${HX_TAR}"
tar -xf "${HX_TAR}" -C ~/.opt
rm -rf "${HX_TAR}"
# }}}

# nvim {{{
NVIM_TAR="nvim-linux64.tar.gz"
wget "https://github.com/neovim/neovim/releases/download/stable/${NVIM_TAR}"
tar -xf "${NVIM_TAR}" -C ~/.opt
rm -f "${NVIM_TAR}"
python3 -mpip install --user neovim
# }}}

# fzf {{{
FZF_VER="0.44.0"
FZF_TAR="fzf-${FZF_VER}-linux_amd64.tar.gz"
wget "https://github.com/junegunn/fzf/releases/download/${FZF_VER}/${FZF_TAR}"
tar -xf "${FZF_TAR}" -C ~/.local/bin
rm -rf "${FZF_TAR}"
# }}}

# rust cli {{{
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
	fd-find   # find
	git-delta # diff
	ripgrep   # ag, ack
	starship  # need to config shell and install nerd fonts
	zoxide    # cd, need to config shell
)
cargo binstall --no-confirm --no-symlinks "${bins[@]}"

declare -a tools=(
	bandwhich
	bat    # cat
	bottom # top, htop
	broot
	dufs
	du-dust # du
	erdtree
	exa   # ls
	gitui # git, lazygit
	hyperfine
	just  # make
	procs # ps
	# sccache # depends on pkg-config
	sd   # sed
	skim # fzf
	stylua
	tealdeer # tldr
	topgrade
	tokei
	xcp    # cp
	yazi-fm   # ranger
	zellij # tmux, screen
)

declare -A status
for bin in "${tools[@]}"; do
	#cargo quickinstall "$bin" &
	cargo binstall --no-confirm --no-symlinks "$bin" &
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
# }}}

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
