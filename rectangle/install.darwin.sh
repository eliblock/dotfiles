#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Some configuration for rectangle is _not_ exposed through the preferences
# menu. Learn more:
# * https://github.com/rxhanson/Rectangle/blob/master/TerminalCommands.md
# * see all current preferences with 'defaults read com.knollsoft.Rectangle'

export tracked="$PWD/com.knollsoft.Rectangle.plist"
export installed="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"

if ! cmp "$tracked" "$installed"; then
  cat << RECTANGLE_PREFS
• ⚠️  rectangle preferences differ! Manual action required:
  ⚠️  to update this machine's preferences, run:
  ⚠️  cp ~/$(realpath --relative-to="$HOME" "$tracked") ~/$(realpath --relative-to="$HOME" "$installed")
  ⚠️  alternatively, to update tracked preferences, run
  ⚠️  cp ~/$(realpath --relative-to="$HOME" "$installed")  ~/$(realpath --relative-to="$HOME" "$tracked")
  ⚠️  then commit the changes.
  ⚠️
  ⚠️  restart rectangle after updating preferences
RECTANGLE_PREFS
fi
