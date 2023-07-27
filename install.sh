#!/bin/bash

# set -euo pipefail; shopt -s failglob # safe mode
# -u : cause sdkman throw "unbound variable" error
set -x

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

bash ${SCRIPT_DIR}/install_nerdfonts.sh
bash ${SCRIPT_DIR}/install_conf.sh
bash ${SCRIPT_DIR}/install_tools.sh
