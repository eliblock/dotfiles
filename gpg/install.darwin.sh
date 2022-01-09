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

# If ~/.gnupg was created during file linking, it may have improper permissions
# Make sure that the .gnupg directory and its contents is accessibile by you
chown -R "$(whoami)" ~/.gnupg/

# Limit access on the directory and assign access on all existing files
chmod 700 ~/.gnupg
