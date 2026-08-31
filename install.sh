#!/bin/bash

# set -euo pipefail; shopt -s failglob # safe mode
# -u : cause sdkman throw "unbound variable" error
set -Eeuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=install_lib.sh
source "$SCRIPT_DIR/install_lib.sh"

run_once bash "$SCRIPT_DIR/install_nerdfonts.sh"
run_once bash "$SCRIPT_DIR/install_conf.sh"
run_once bash "$SCRIPT_DIR/install_tools.sh"
