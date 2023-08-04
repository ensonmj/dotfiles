#!/bin/bash

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

declare -a tools=(
	bandwhich
	bat
	bottom
	broot
	dufs
	du-dust
	erdtree
	gitui
	hyperfine
	just
	procs
	# sccache # depends on pkg-config
	sd
	skim
	stylua
	tealdeer
	topgrade
	tokei
	xcp
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

echo "All done, $(date)"
