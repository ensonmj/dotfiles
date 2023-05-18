#!/bin/bash

if [ ! -f /workspaces/gluten/.clangd ]; then
    cat << EOF > /workspaces/gluten/.clangd
CompileFlags:
  Add: 
    - -ferror-limit=0
    - "--include-directory=/workspaces/gluten/ep/build-velox/build/velox_ep/velox/external/xxhash"
EOF
fi
