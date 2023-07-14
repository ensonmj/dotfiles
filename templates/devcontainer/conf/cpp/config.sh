#!/bin/bash

# vscode extensions
declare -a exts=(
    ms-vscode.cpptools
    ms-vscode.cmake-tools
    xaver.clang-format
    llvm-vs-code-extensions.vscode-clangd
)
for ext in "${exts[@]}"; do
    code --install-extension "$ext"
done

# config
CUR_DIR=$(dirname "${BASH_SOURCE[0]}")
merge_vsconf "${CUR_DIR}/vscode/*" "${WORKSPACE_DIR}/.vscode"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    ccache cmake clang-format clangd-12 gdb gdbserver ninja-build
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100

# for gdb attach
sudo sed -i /kernel.yama.ptrace_scope/s/[0-9]$/0/g /etc/sysctl.d/10-ptrace.conf
# if kernel.yama.ptrace_scope in /etc/sysctl.d/10-ptrace.conf not set to 0
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

[[ -f ${WORKSPACE_DIR}/.clangd ]] || ln -s ${CUR_DIR}/.clangd ${WORKSPACE_DIR}/.clangd
[[ -f ${WORKSPACE_DIR}/.clang-format ]] || ln -s ${CUR_DIR}/.clang-format ${WORKSPACE_DIR}/.clang-format
[[ -f ${WORKSPACE_DIR}/.clang-tidy ]] || ln -s ${CUR_DIR}/.clang-tidy ${WORKSPACE_DIR}/.clang-tidy