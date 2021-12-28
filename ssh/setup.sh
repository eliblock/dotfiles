#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# shellcheck disable=SC1091
source ../system_checks.sh

echo '~~~~~~~~~~~ ~~~~~~~~~~ configuring ssh for GitHub access ~~~~~~~~~~ ~~~~~~~~~~~'

github_noreply_email="3347571+eliblock@users.noreply.github.com"
make_sk_key=false
key_file_name="$HOME/.ssh/id_ed25519_github"
if command_available ykman; then
  if [ "$(ykman list | wc -l)" -gt 0 ]; then
    make_sk_key=true
    key_file_name="$HOME/.ssh/id_ed25519_sk_github"
    echo "YubiKey detected. Will create a YubiKey-backed key."
  fi
fi

if [ -f "$key_file_name" ]; then
  echo "🛑 A key already exists at $key_file_name. Clean up and try again."
  exit 1
fi

read -rp "✨ Using ssh-keygen to create a key ($key_file_name). Follow the prompts. Ready to continue? [y/N]: " CONTINUE
if ! [[ "$CONTINUE" =~ ^[Yy]$ ]]; then
  echo "🛑 Okay! Try again when you're ready."
  exit 0
fi
unset CONTINUE

if "$make_sk_key"; then
  # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key-for-a-hardware-security-key
  ssh-keygen -t ed25519-sk -C "$github_noreply_email" -f "$key_file_name"
else
  # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
  ssh-keygen -t ed25519 -C "$github_noreply_email" -f "$key_file_name"
fi

read -rp "✨ A key was generated! Adding it to ssh-agent (you will be prompted for the password you set). Ready to continue? [y/N]: " CONTINUE
if ! [[ "$CONTINUE" =~ ^[Yy]$ ]]; then
  echo "🛑 Okay! Try again when you're ready."
  exit 0
fi
unset CONTINUE
eval "$(ssh-agent -s)" 1> /dev/null
ssh-add "$key_file_name"

cat << GITHUB_STEPS
⚠️  manual action required ⚠️

A key was successfully created ($key_file_name) but manual steps are required to
complete setup:
* copy the public key to your clipboard
  pbcopy < $key_file_name.pub
* add a new ssh key to your GitHub account. Be sure to give the key a meaningful
  name (e.g., $(hostname), or some other identifier for this machine)
  https://github.com/settings/ssh/new
GITHUB_STEPS
