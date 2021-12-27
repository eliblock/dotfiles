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

    # Next, set up the new brew installation to be usable by the remainder of
    # this script. A similar configuration is set in the ~/.shared-login-profile
    #
    # Brew is installed in different places on apple silicon vs. intel. The
    # /opt/** directory is not automatically added to the path, so we need to
    # find brew before we can use it.
    if [ -x /opt/homebrew/bin/brew ]; then # apple silicon
      brew=/opt/homebrew/bin/brew
    elif [ -x /usr/local/bin/brew ]; then # intel
      brew=/usr/local/bin/brew
    fi
    # Add brew to path and set useful brew-related environment variables
    if test -n "${brew}"; then
      eval "$($brew shellenv)"
    fi
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

      target=$HOME"/."$(basename "$dot_link" | sed 's/.link//' | sed 's/~~/\//g')

      # if the target is not already a symbolic link
      # bash test options: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
      if [ ! -L "$target" ]; then
        set +u
        if [ -z "$PRINTED_LINK_MESSAGE" ]; then
          echo
          echo "🔗 linking dotfiles..."
          PRINTED_LINK_MESSAGE=1
        fi
        set -u

        # move the file if it already exists (and is a regular file)
        if [ -f "$target" ]; then
          moved_to_name="$target.original.$(date +"%Y-%m-%d_%H-%M-%S%Z")"
          echo -e "\t⚠️  renaming $target to $moved_to_name"
          cat << MOVED_NOTE | cat - "$target" > "$moved_to_name"
## ~~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~ THIS FILE WAS MOVED ~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~~
## Original name: $target
## Moved on: $(date +"%Y-%m-%d at %H:%M:%S%Z")
## Moved by: $(realpath "$0")
## ~~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~ THIS FILE WAS MOVED ~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~~
MOVED_NOTE
          rm "$target"
        fi

        echo -e "\t• $target → $dot_link"
        mkdir -p "$(basename "$target")"
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
echo "✅ done. Open a new shell (or, if login items have not changed, run: source ~/.zshrc)"
