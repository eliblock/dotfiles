#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

eval "$(fnm env)"


echo "• installing node..."
fnm install --lts

echo "• installing yarn..."
npm install -g yarn
corepack enable
