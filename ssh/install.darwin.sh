#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

if ! [ -f "$HOME/.ssh/untracked-local-config" ]; then
  echo '• initializing ~/.ssh/untracked-local-config...'
  cat << EOF > "$HOME/.ssh/untracked-local-config"
## As an escape hatch, additional ssh configuration goes in this untracked file
## This file is included by ~/.ssh/config
EOF
fi
