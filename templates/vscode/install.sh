#!/bin/bash

CUR_DIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

# Get the options
case $1 in
linux)
	TARGET_PATH=$HOME/.vscode-server/data/Machine/
	;;
wsl)
	#sudo apt install --no-install-recommends wslu
	#TARGET_PATH=$(wslpath "$(wslvar USERPROFILE)")/AppData/Roaming/Code/User
	Please use "install.bat from cmd.exe with administrator privileges"
	exit
	;;
*)
	echo "Unknown option"
	echo "./install.sh linux|wsl"
	exit
	;;
esac

function link() {
	SRC=$1
	TARGET=$2
	mv ${TARGET}{,.bak}
	ln -s ${SRC} ${TARGET}
	# cp ${SRC} ${TARGET}
}

link ${CUR_DIR}/settings.json ${TARGET_PATH}/settings.json
link ${CUR_DIR}/keybindings.json ${TARGET_PATH}/keybindings.json

function trim_comment() {
	sed "s|[ \t]*//.*$||" $1 | sed "/^$/d"
}
jq '.recommendations[]' <(trim_comment ${CUR_DIR}/extensions.json) | xargs -n 1 code --install-extension
