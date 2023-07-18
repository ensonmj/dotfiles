#!/bin/bash

# vscode extensions
# declare -a exts=(
#     mutantdino.resourcemonitor
#     yzhang.markdown-all-in-one
#     ryu1kn.partial-diff
#     iliazeus.vscode-ansi
#     Gruntfuggly.todo-tree
#     eamodio.gitlens
#     mhutchie.git-graph
#     GitHub.vscode-pull-request-github
# )
# for ext in "${exts[@]}"; do
#     code --install-extension "$ext"
# done

# config
CUR_DIR=$(dirname "${BASH_SOURCE[0]}")
# merge_vsconf "${CUR_DIR}/vscode/*" "${WORKSPACE_DIR}/.vscode"

safe_link ${CUR_DIR}/justfile ${WORKSPACE_DIR}/justfile

# some tools (fd, rg) respect .gitignore, also respect .ignore
# amend some pattern in .gitignore
echo <<EOF >${WORKSPACE_DIR}/.ignore
!build
!*-build
EOF