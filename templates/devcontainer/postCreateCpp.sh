#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CLANGD_CONF=${SCRIPT_DIR}/../.clangd
if [ ! -f $CLANGD_CONF ]; then
    cat << EOF > $CLANGD_CONF
CompileFlags:
  Add: 
    - -ferror-limit=0
    - "--include-directory=/workspaces/gluten/ep/build-velox/build/velox_ep/velox/external/xxhash"
EOF
fi
