#!/bin/bash
set -euo pipefail

on_macos() {
  [ "$(uname)" == Darwin ]
  return $?
}

command_available() {
  which "$1" > /dev/null
}
