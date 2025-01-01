#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"


echo "• installing various python versions..."
uv python install 3.10 3.12


uv tool install ipython
uv tool install ruff
uv tool install --with tox-uv tox

bash "$SCRIPT_DIR/uv-python-symlink.sh"
