#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

DEFAULT_RUBY=3.4.1

read -p "❓💎 install ruby $DEFAULT_RUBY as default ruby? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "• installing ruby $DEFAULT_RUBY as default ruby..."
    ruby-install ruby "$DEFAULT_RUBY" --no-reinstall

    # chruby will pick up ~/.ruby-version as the default version of ruby to use
    echo "ruby-$DEFAULT_RUBY" > "$HOME/.ruby-version"
fi
