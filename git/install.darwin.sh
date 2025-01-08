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
#
## To include _another_ gitconfig file optionally for some directory, create the
## file (e.g., ~/.untracked-work-gitconfig):
# [user]
#    email = e@work.com
## Then optionally include it in this file
# [includeIf "gitdir:~/code/work/]
#   path = ~/.untracked-work-gitconfig
GITCONFIG
fi
