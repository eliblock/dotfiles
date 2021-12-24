#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

source system_checks.sh

echo "👋 configuring $(hostname) using ${BASH_SOURCE[0]}"

# git submodules are used for some dependencies - like zsh plugins
echo '📦 downloading up to date submodules'
git submodule init
git submodule update

if on_macos; then
  # Keep system from sleeping until script exits (ignored unless plugged in)
  caffeinate -s -w $$ &

  if ! command_available brew; then
    echo
    echo '🍺 installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo '🍺 checking brew bundle...'
  if ! brew bundle check; then
    echo '🍺 brew bundle outdated, installing the new brew bundle'
    brew bundle install
  fi

  # shellcheck disable=SC2231
  for dot_link in $SCRIPT_DIR/**/*.link; do
    # if the dot_link is not itself a symbolic link
    if [ ! -L "$dot_link" ]; then

      target=$HOME"/."$(basename "$dot_link" | sed 's/.link//')

      # if the target is not already a symbolic link
      if [ ! -L "$target" ]; then
        set +u
        if [ -z "$PRINTED_LINK_MESSAGE" ]; then
          echo
          echo "🔗 linking dotfiles..."
          PRINTED_LINK_MESSAGE=1
        fi
        set -u

        echo -e "\t• $target → $dot_link"
        ln -s "$dot_link" "$target"
      fi
    fi
  done


  echo
  echo "🧙 running installers..."
  # shellcheck disable=SC2231
  for installer in $SCRIPT_DIR/**/install.darwin.sh; do
    bash "$installer"
  done

  # set up pre-commit for this repo
  pre-commit install --install-hooks 1> /dev/null
fi

echo
echo "✅ done. Open a new shell, or run: source ~/.zshrc"
