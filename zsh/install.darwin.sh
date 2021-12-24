#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Assumes macOS defaults are configured, including:
# * zsh is installed
# * zsh is the default shell

if ! [ -d "$HOME/.oh-my-zsh" ]; then
  echo '• installing oh-my-zsh...'
  # * KEEP_ZSHRC instructs the installer to _not_ overwrite ~/.zshrc (needed
  #   because we manage ~/.zshrc elsewhere)
  # * --unattended instructs the installer to avoid interactive prompts
  KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended
fi

# shellcheck disable=SC2231
for plugin_directory in $SCRIPT_DIR/plugins/*; do
  target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$( basename "$plugin_directory" )"

  if [ ! -L "$target" ]; then
    set +u
    if [ -z "$PRINTED_LINK_MESSAGE" ]; then
      echo "• linking oh-my-zsh plugins..."
      PRINTED_LINK_MESSAGE=1
    fi
    set -u

    echo -e "\t• $target → $plugin_directory"
    ln -s "$plugin_directory" "$target"
  fi
done
