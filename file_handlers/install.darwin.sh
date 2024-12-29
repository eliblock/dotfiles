#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# shellcheck disable=SC1091
source ../system_checks.sh

if command_available duti; then
  if app_installed 'Cursor'; then
    package_id=$(osascript -e 'id of app "Cursor"')

    for extension in py rb txt md; do
      duti -s "$package_id" ".$extension" all
    done
  else
    echo "VS Code not found, skipping file handlers"
  fi
else
  echo "duti not available. Ensure brewfile was installed"
fi
