#!/bin/bash

CUR_DIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))
# USR_DIR=$(cd ${CUR_DIR}/../../.. && pwd)
USR_DIR=$(wslpath "$(wslvar USERPROFILE)")

function link() {
	SRC=$1
	TARGET=$2
	mv ${TARGET}{,.bak}
	ln -s ${SRC} ${TARGET}
	# cp ${SRC} ${TARGET}
}

# wsl2 config
cp ${CUR_DIR}/.wslconfig ${USR_DIR}
# use wsl2 ssh in windows cli
cp ${CUR_DIR}/ssh.bat ${USR_DIR}
# link dotfiles from windows to wsl2
link ${USR_DIR}/.dotfiles ${HOME}/.dotfiles
