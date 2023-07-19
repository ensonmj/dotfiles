#!/bin/bash
set -x

export SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
export WORKSPACE_DIR=$(cd -- "$SCRIPT_DIR/.." &> /dev/null && pwd )

# export PATH=`ls -t /vscode/vscode-server/bin/linux-x64/*/bin/remote-cli | head -n1`:$PATH
# export VSCODE_IPC_HOOK_CLI=`ls -t /tmp/vscode-ipc-*.sock | head -n1`
# jq '.recommendations[]' ${WORKSPACE_DIR}/.vscode/extensions.json | xargs -L 1 code --install-extension