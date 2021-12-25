#!/bin/bash
set -euo pipefail

if ! [ -f "$HOME/.untracked-local-gitconfig" ]; then
  cat << GITCONFIG > "$HOME/.untracked-local-gitconfig"
## Place any git configuration which you do _not_ want tracked in shared dotfiles
## in this file.

## For example, to globally enable commit signing for this machine only, fill in
## KEYID and uncomment the following
# [user]
#   signingkey = KEYID
# [commit]
#   gpgsign = true
GITCONFIG
fi
