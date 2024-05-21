#!/bin/bash

echo "Start to install some command line tools, $(date)"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source $SCRIPT_DIR/os_env.sh

mkdir -p $HOME/.opt
mkdir -p $HOME/.local/bin

# helix {{{
HX_VER="24.03"
HX_TAR="helix-${HX_VER}-x86_64-linux.tar.xz"
wget "https://github.com/helix-editor/helix/releases/download/${HX_VER}/${HX_TAR}"
tar -xf "${HX_TAR}" -C ~/.opt
rm -rf "${HX_TAR}"
python3 -mpip install --user 'python-lsp-server[all]'
# }}}

# nvim {{{
NVIM_TAR="nvim-linux64.tar.gz"
wget "https://github.com/neovim/neovim/releases/download/stable/${NVIM_TAR}"
tar -xf "${NVIM_TAR}" -C ~/.opt
rm -f "${NVIM_TAR}"
python3 -mpip install --user neovim
# }}}

# wezterm {{{
case $OS in
*Ubuntu*)
	curl -LO https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb
	sudo apt install -y ./wezterm-20240203-110809-5046fc22.Ubuntu22.04.deb
	# https://wezfurlong.org/wezterm/faq.html?h=terminfo#how-do-i-enable-undercurl-curly-underlines
	# terminfo
	tempfile=$(mktemp) \
	    && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo \
	    && tic -x -o ~/.terminfo $tempfile \
	    && rm $tempfile
	# need to set TERM=wezterm, eg. `TERM=wezterm nvim`
	;;
*Arch*) ;;
esac
# }}}

# fzf {{{
FZF_VER="0.47.0"
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
	xcp     # cp
	yazi-fm # ranger
	zellij  # tmux, screen
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

# wezterm {{{
# https://tjex.net/hacks/installing-wezterm-on-a-raspberry-pi-or-linux-server/
# git clone --depth=1 --branch=main --recursive https://github.com/wez/wezterm.git
# cd wezterm
# git submodule update --init --recursive
# ./get-deps
# cargo build --release
# cd target/release
# sudo mkdir -p /usr/local/bin /etc/profile.d
# sudo install -Dm755 assets/open-wezterm-here wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes -t /usr/local/bin
# sudo install -Dm644 assets/shell-integration/* -t /etc/profile.d
# sudo install -Dm644 assets/shell-completion/zsh /usr/local/share/zsh/site-functions/_wezterm
# sudo install -Dm644 assets/shell-completion/bash /etc/bash_completion.d/wezterm
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
