#!/bin/bash

CUR_DIR=$(dirname "${BASH_SOURCE[0]}")
[[ -f ${WORKSPACE_DIR}/justfile ]] || ln -s ${CUR_DIR}/justfile ${WORKSPACE_DIR}/justfile

# some tools (fd, rg) respect .gitignore, also respect .ignore
# amend some pattern in .gitignore
echo <<EOF >${WORKSPACE_DIR}/.ignore
!build
!*-build
EOF