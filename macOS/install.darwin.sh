#!/bin/bash
set -euo pipefail

# Resources + inspiration:
# - https://mths.be/macos
# - https://github.com/kevinSuttle/macOS-Defaults/
# - https://macos-defaults.com/

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo '• configuring macOS settings...'

# Close any open System Preferences panes to prevent conflicts
osascript -e 'tell application "System Preferences" to quit'

##########
# Finder & General UI
##########

# Require password 2 seconds after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 2
# Start screensaver after 15m
defaults write com.apple.screensaver idleTime -int 900
# Some screen saver settings do not take effect until after reboot/restart

# Disable creation of .DS_Store files on network drives.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Do not display hidden files
defaults write com.apple.Finder "AppleShowAllFiles" -bool "false"
# Kill it to apply settings
killall Finder

# Expand the Save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Sometimes macs have this enabled (set to Yes), which prevents the majority of
# the UI from entering dark mode when activated in System Preferences. Disable
# it so the settings work! Requires log out / log in.
# https://osxdaily.com/2018/10/15/dark-menu-dock-light-theme-macos/
defaults write -g NSRequiresAquaSystemAppearance -bool No

##########
# Dock, menu bar, hot corners
##########

# Hide dock when not in use
defaults write com.apple.dock autohide -bool true
# Dock on bottom
defaults write com.apple.dock orientation -string "bottom"
# System Preferences > Dock > Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true
# Kill it to apply settings
killall Dock

# Blink the ":" in the date/time
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true"
# Kill to apply settings
killall SystemUIServer

# Show 24-hour clock in format "Mon Jan 1 13:01"
# https://www.tech-otaku.com/mac/setting-the-date-and-time-format-for-the-macos-menu-bar-clock-using-terminal
defaults write com.apple.menuextra.clock DateFormat 'EEE MMM d HH:mm'

# Do not show spotlight in the menu bar
defaults write com.apple.Spotlight MenuItemHidden -int 1

# Find relevant configs with: defaults find 'NSStatusItem'
# Do not show Zoom in the menu bar
defaults write us.zoom.xos 'NSStatusItem Visible Item-0' 0
killall zoom.us

# Do not show 1Password 7 in the menu bar
defaults write com.agilebits.onepassword7 'NSStatusItem Visible Item-0' 0
killall '1Password 7'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# Top right corner → Start screensaver
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0

##########
# Safari
##########

# Enable developer tools
defaults write com.apple.Safari "WebKitPreferences.developerExtrasEnabled" -bool true

##########
# Other
##########
