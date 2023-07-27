#!/bin/bash

echo "Start to install some command line tools, $(date)"

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

source ~/.cargo/env
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
