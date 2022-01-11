#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

DEFAULT_NODE=16.4.0

# Load nvm for this session (also done in shared-interactive-profile)
if [ -x /opt/homebrew/bin/brew ]; then # apple silicon
  NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
elif [ -x /usr/local/bin/brew ]; then # intel
  NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
fi
export NVM_DIR

echo "• installing node $DEFAULT_NODE..."
nvm install "$DEFAULT_NODE" 1> /dev/null
nvm alias default "$DEFAULT_NODE"
