#!/bin/bash

RED="\033[1;31m"
NC="\033[0m"

function trim_comment() {
    # can trim "//xxx" in "http://xxx"
    # "s|^[ \t]*//.*$||" all comment line
    # "s|[ \t]+//.*$||" comment at the end of line
    sed -e "s|^[ \t]*//.*$||" -e "s|[ \t]+//.*$||" $1 | sed "/^$/d"
}

function merge_json() {
    jq -s add <(trim_comment $1) <(trim_comment $2)
}

function merge_nested_arr() {
    jq -s '[.[] | to_entries] | flatten | reduce .[] as $dot ({}; .[$dot.key] += $dot.value)' <(trim_comment $1) <(trim_comment $2)
    # jq -s '.[0] + .[1]' <(trim_comment $1) <(trim_comment $2)
}

function merge_vsconf() {
    SRC=$1
    TARGET=$2
    mkdir -p ${TARGET}
    for SRC_PATH in $SRC; do
        if test -f ${SRC_PATH}; then
            FILE="$(basename -- ${SRC_PATH})"
            TARGET_PATH=${TARGET}/${FILE}
            if [[ -f ${TARGET_PATH} ]]; then
                TMP=${TARGET_PATH}.tmp
                if [[ "$FILE" == "extensions.json" ]]; then
                    merge_nested_arr ${TARGET_PATH} ${SRC_PATH} > ${TMP}
                else
                    merge_json ${TARGET_PATH} ${SRC_PATH} > ${TMP}
                fi
                if [[ $? != 0 ]]; then
                    echo -e "${RED}Failed to merge ${SRC_PATH} > ${TARGET_PATH}${NC}"
                    rm ${TMP}
                    continue
                fi
                rm ${TARGET_PATH}
                mv ${TMP} ${TARGET_PATH}
            else
                trim_comment ${SRC_PATH} > ${TARGET_PATH}
            fi
        fi
    done
}

function install_vsconf() {
    SRC_DIR=$1
    WORKSPACE_DIR=$2

    # jq '.recommendations[]' ${SRC_DIR}/vscode/extensions.json | xargs -L 1 code --install-extension
    merge_vsconf "${SRC_DIR}/vscode/*" "${WORKSPACE_DIR}/.vscode"
    source ${SRC_DIR}/config.sh
}


function safe_link() {
    SRC=$1
    TARGET=$2
    ([[ -e ${TARGET} ]] && echo -e "${RED}${TARGET} already exist${NC}") || ln -s ${SRC} ${TARGET}
}