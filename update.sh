#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

C_RED='\033[0;31m'
C_ORANGE='\033[0;33m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_PURPLE='\033[0;35m'
C_RESET='\033[0m'

if [  "$(git symbolic-ref -q --short HEAD)" != "main" ]; then
  echo -e "$(cat << EOF
${C_RED}ERROR: ~/.dotfiles is not on the main branch!$C_RESET
${C_PURPLE}To resolve: switch to the main branch by running:$C_RESET
cd $PWD && git checkout main && cd -
${C_PURPLE}Then try this script again:$C_RESET
$0

${C_PURPLE}Otherwise, directly run the installer:$C_RESET
$SCRIPT_DIR/install.sh
EOF
  )"
  exit 1
fi

un_checked_in_changes=false
if [ -n "$(git status --porcelain)" ]; then
  echo -e "$(cat << EOF
${C_ORANGE}NOTICE: ~/.dotfiles has not-checked-in changes!$C_RESET
${C_PURPLE}Commit (or remove) your changes to resolve.
This issue will ${C_ORANGE}not$C_PURPLE block installation unless the branch is also out of date.$C_RESET

EOF
  )"
  un_checked_in_changes=true
fi

echo -e "${C_BLUE}Fetching ~/.dotfiles origin...$C_RESET"
git fetch origin main

echo -e "${C_GREEN}...complete!\n$C_RESET"
if [ "$(git rev-parse main)" != "$(git rev-parse origin/main)" ]; then
  echo -e "${C_PURPLE}NOTICE: ~/.dotfiles main branch is not up to date.\n$C_RESET"
  if [ "$un_checked_in_changes" == 'true' ]; then
    echo -e "$(cat << EOF
${C_RED}ERROR: main branch is not up to date _and_ there are not-checked-in changes.$C_RESET
${C_PURPLE}This must be resolved manually (or directly run the installer: $C_RESET$SCRIPT_DIR/install.sh$C_PURPLE)$C_RESET
EOF
    )"
    exit 1
  else
    echo -e "${C_BLUE}Updating the main branch...$C_RESET"
    if git pull origin main; then
      echo -e "${C_GREEN}...complete!\n$C_RESET"
    else
      echo -e "$(cat << EOF

${C_RED}ERROR: main branch pull failed.$C_RESET
${C_PURPLE}This must be resolved manually (to start: ${C_RESET}cd $PWD$C_PURPLE)$C_RESET
EOF
      )"
      exit 1
    fi
  fi
fi

echo -e "${C_GREEN}~/.dotfiles is up to date. Running the installer...$C_RESET"
bash ./install.sh
