#!/bin/bash

# config
CUR_DIR=$(dirname "${BASH_SOURCE[0]}")
source ${SCRIPT_DIR}/helper.sh
# merge_vsconf "${CUR_DIR}/vscode/*" "${WORKSPACE_DIR}/.vscode"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    ccache cmake gdb gdbserver