#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Generate ~/.fzf.zsh and ~/.fzf.bash files
echo '• installing fzf shell completion...'
"$(brew --prefix)/opt/fzf/install" \
    --no-update-rc \
    --completion --no-key-bindings \
    --no-fish \
    1> /dev/null
