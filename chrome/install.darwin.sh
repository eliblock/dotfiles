#!/bin/bash
set -euo pipefail

## Chrome Policies
# Apply policies as _recommendations_ (not mandatory).
# Resources + inspiration:
# - chrome://policy
# - https://chromeenterprise.google/policies

# Do not prompt to collect passwords
defaults write com.google.Chrome.plist PasswordManagerEnabled -bool false

# Do not attempt to autofill credit cards
defaults write com.google.Chrome.plist AutofillCreditCardEnabled -bool false

# Disable data collection keyed on URL
defaults write com.google.Chrome.plist UrlKeyedAnonymizedDataCollectionEnabled -bool false

# Default to https connections
defaults write com.google.Chrome.plist HttpsOnlyMode force_enabled

# Clean up UI clutter
defaults write com.google.Chrome.plist SideSearchEnabled -bool false
defaults write com.google.Chrome.plist ShowHomeButton -bool false
defaults write com.google.Chrome.plist ShowFullUrlsInAddressBar -bool true

# Scanning
defaults write com.google.Chrome.plist DownloadRestrictions -int 4
defaults write com.google.Chrome.plist SafeBrowsingProtectionLevel -int 1

## Extensions
# Prompt Chrome to install these extensions (and notify user) on next boot
# https://developer.chrome.com/docs/extensions/mv3/external_extensions/#preferences
extensions=()
extensions+=(pkehgijcmpdhfbdbbnkijodmdjhbjlgp) # PrivacyBadger
extensions+=(cjpalhdlnbpafiamejdnhcphjbkeiagm) # UBlock Origin

extension_root="$HOME/Library/Application Support/Google/Chrome/External Extensions"
mkdir -p "$extension_root"
for i in "${extensions[@]}"; do
    extension_file="$extension_root/$i.json"
    if ! [ -f "$extension_file" ]; then
        echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > "$extension_root/$i.json"
    fi
done
