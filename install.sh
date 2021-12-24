#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

source system_checks.sh

echo "👋 configuring $(hostname) using ${BASH_SOURCE[0]}"

if on_macos; then
  # Keep system from sleeping until script exits (ignored unless plugged in)
  caffeinate -s -w $$ &

  if ! command_available brew; then
    echo '🍺 installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo '🍺 checking brew bundle...'
  if ! brew bundle check; then
    echo '🍺 brew bundle outdated, installing the new brew bundle'
    brew bundle install
  fi

  echo
  echo "🧙 running installers..."
  for installer in $SCRIPT_DIR/**/install.darwin.sh; do
    bash "$installer"
  done
fi

echo
echo "✅ done"
