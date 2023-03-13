#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

DEFAULT_PYTHON=3.11

echo "• installing python $DEFAULT_PYTHON as default python..."
pyenv install "$DEFAULT_PYTHON" --skip-existing

# update ~/.pyenv/version, which pyenv uses to determine default version
pyenv global "$DEFAULT_PYTHON"
