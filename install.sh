#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
source ~/.cargo/env
# cargo install sccache
cargo install --locked bat
cargo install --locked bottom
cargo install --locked delta
cargo install --locked fd-find
cargo install --locked hyperfine
cargo install --locked just
cargo install --locked miniserve
cargo install --locked procs
cargo install --locked ripgrep
#cargo install --locked starship # need to config shell and nerd fonts
cargo install --locked tokei
# cargo install --locked zoxide # need to config shell
