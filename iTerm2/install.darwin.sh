#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo '• configuring iTerm2 to track custom preferences...'

# iTerm2 uses a custom directory for preferences
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
# Specify the directory as this one
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$SCRIPT_DIR"
