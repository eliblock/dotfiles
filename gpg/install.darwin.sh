#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# shellcheck disable=SC1091
source ../system_checks.sh

# Debugging something with gpg-agent? The following commands may be useful:
# * terminate the current running agent:
#   gpgconf --kill gpg-agent
# * start the agent (also started on demand by some gpg commands)
#   gpg-connect-agent /bye
# * restart the agent passing the --verbose flag for debugging purposes
#   killall gpg-agent && eval $(gpg-agent --default-cache-ttl 60 --daemon --verbose)
# Additional debugging suggestions:
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html

# gpg-agent expects pinentry to be in different places on various OSs, and
# furthermore we want to use pinentry-mac which brew installs to different
# places depending on the machine's cpu
#
# set up a symlink for pinentry-dotfile-custom which points to the proper local
# pinentry-mac installation. This path is set in ~/.gpg-agent.conf as the place
# to check for pinentry-program
if command_available pinentry-mac; then
  pinentry_symlink=/usr/local/bin/pinentry-dotfile-custom
  if [ ! -L "$pinentry_symlink" ]; then
    echo "• linking $pinentry_symlink → $(which pinentry-mac)..."
    ln -s "$(which pinentry-mac)" "$pinentry_symlink"
  fi
fi

# Making a non-GitHub/gpg related change to ~/.ssh/config? Move ssh config
# management out of this file!
# For now, this should work...
if [ -f "$HOME/.ssh/id_rsa_yubikey.pub" ]; then
  echo '• configuring ssh to use yubikey for github...'
  NEW_SSH_CONFIG=$(cat << SSH_CONFIG
## This file is managed by ~/.dotfiles
## Changes _will_ be overwritten
Host github.com
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_rsa_yubikey.pub
SSH_CONFIG
  )
  safe_overwrite "$HOME/.ssh/config" "$NEW_SSH_CONFIG" "$(realpath "$0")"
elif [ -f "$HOME/.ssh/id_ed25519_github" ]; then
  echo '• configuring ssh to use local id_ed25519_github key for github...'
  NEW_SSH_CONFIG=$(cat << SSH_CONFIG
## This file is managed by ~/.dotfiles
## Changes _will_ be overwritten
Host github.com
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519_github
SSH_CONFIG
  )
  safe_overwrite "$HOME/.ssh/config" "$NEW_SSH_CONFIG" "$(realpath "$0")"
else
  echo '⚠️  no valid identity for github detected. ~/.ssh/config not configured'
fi
