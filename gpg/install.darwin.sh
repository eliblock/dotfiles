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
# places depending on the machine's cpu. To make matters worse, symlinks are
# not followed within the gpg-agent.conf file
#
# Overwrite ~/.gnupg/gpg-agent.conf with the proper configuration for this
# platform
if command_available pinentry-mac; then

  gpg_agent_file=$(cat << GPG_AGENT
## This file is managed by $(realpath "$0")
## All updates will be overwritten

## Unless another option file is specified (with the --options flag), GnuPG
## Agent uses this file (~/.gnupg/gpg-agent.conf).
##
## Configuration heavily based on:
## https://github.com/drduh/config/blob/master/gpg-agent.conf

# program used for pin entry (installed via brew)
# gpg-agent expects pinentry to be in different places on various OSs, and
# furthermore we want to use pinentry-mac which brew installs to different
# places depending on the machine's cpu
pinentry-program $(which pinentry-mac)

# how long (in seconds) a password is cached before it must be re-entered. The
# timer is reset to this value each time the cached password is used
default-cache-ttl 600
# maximum time (in seconds) a password may be cached, even if its cache ttl
## timer has been reset
max-cache-ttl 7200
GPG_AGENT
  )

  safe_overwrite "$HOME/.gnupg/gpg-agent.conf" "$gpg_agent_file" "$(realpath "$0")"
fi

# If ~/.gnupg was created during file linking, it may have improper permissions
# Make sure that the .gnupg directory and its contents is accessibile by you
chown -R "$(whoami)" ~/.gnupg/

# Limit access on the directory and assign access on all existing files
chmod 700 ~/.gnupg
