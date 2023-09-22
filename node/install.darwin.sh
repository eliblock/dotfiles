#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

DEFAULT_NODE=18

mkdir -p ~/.nvm

# Load nvm for this session (also done in shared-interactive-profile)
NVM_DIR="$HOME/.nvm"
if [ -x /opt/homebrew/bin/brew ]; then # apple silicon
  # shellcheck disable=SC1091
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
elif [ -x /usr/local/bin/brew ]; then # intel
  # shellcheck disable=SC1091
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
fi
export NVM_DIR

echo "• installing node $DEFAULT_NODE..."
nvm install "$DEFAULT_NODE" 1> /dev/null
nvm alias default "$DEFAULT_NODE"
