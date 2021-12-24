#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

if ! docker stats --no-stream 1> /dev/null 2> /dev/null; then
  echo '• opening Docker...'
  open --background -a Docker
fi
