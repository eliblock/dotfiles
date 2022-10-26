#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

DEFAULT_RUBY=3.1.2

echo "• installing ruby $DEFAULT_RUBY as default ruby..."
ruby-install ruby "$DEFAULT_RUBY" --no-reinstall

# chruby will pick up ~/.ruby-version as the default version of ruby to use
echo "ruby-$DEFAULT_RUBY" > "$HOME/.ruby-version"
