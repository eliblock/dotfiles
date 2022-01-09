#!/bin/bash
set -euo pipefail

on_macos() {
  [ "$(uname)" == Darwin ]
  return $?
}

command_available() {
  which "$1" > /dev/null
}

safe_overwrite() {
  # usage: safe_overwrite filename new_file_contents_as_string blame_string

  new_file=$(mktemp)
  echo "$2" > "$new_file"

  if [ -f "$1" ]; then
    if ! diff "$1" "$new_file" 1> /dev/null; then
      moved_to_name="$1.original.$(date +"%Y-%m-%d_%H-%M-%S%Z")"
      echo -e "\t⚠️  renaming $1 to $moved_to_name"
      cat << MOVED_NOTE | cat - "$1" > "$moved_to_name"
## ~~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~ THIS FILE WAS MOVED ~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~~
## Original name: ~/.ssh/config
## Moved on: $(date +"%Y-%m-%d at %H:%M:%S%Z")
## Moved by: $3
## ~~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~ THIS FILE WAS MOVED ~~~~ ~~~~~ ~~~~~ ~~~~~ ~~~~~
MOVED_NOTE
    fi
  fi
  mv "$new_file" "$1"
}
