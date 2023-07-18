#!/bin/bash

CUR_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get the options
case $1 in
    wsl)
        #sudo apt install --no-install-recommends wslu
        TARGET_PATH=$(wslpath "$(wslvar USERPROFILE)")/AppData/Roaming/Code/User
        ;;
    linux)
        TARGET_PATH=$HOME/.vscode-server/data/Machine/
        ;;
    *)
        echo "Unknown option"
        echo "./install.sh wsl|linux"
        exit;
esac

function link ()
{
    SRC=$1
    TARGET=$2
    mv ${TARGET}{,.bak}
    ln -s ${SRC} ${TARGET}
}

link ${CUR_DIR}/settings.json ${TARGET_PATH}/settings.json
link ${CUR_DIR}/keybindings.json ${TARGET_PATH}/keybindings.json

jq '.recommendations[]' ${CUR_DIR}/extensions.json | xargs -n 1 code --install-extension
