#!/usr/bin/env zsh
#
# Apply macOS system defaults. Idempotent — safe to re-run.
#
# Discover the key behind a System Settings toggle with `task macos:defaults:diff`
# (snapshots `defaults read` before/after a UI change so you can diff them).
#
# Reference: https://macos-defaults.com

set -euo pipefail

# Ask for sudo up front and keep it alive for the few commands that need it.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Keyboard
###############################################################################

# Repeat the character when a key is held, instead of showing the accent menu.
# https://macos-defaults.com/keyboard/applepressandholdenabled.html
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Auto-capitalise the start of sentences.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
# Don't substitute "--" with an em dash.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Don't substitute straight quotes with curly quotes.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable autocorrect.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

###############################################################################
# Trackpad
###############################################################################

# Tap to click on a Bluetooth trackpad.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# Tap to click on the built-in trackpad.
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

###############################################################################
# Finder
###############################################################################

# Always show filename extensions.
# https://macos-defaults.com/finder/appleshowallextensions.html
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show hidden (dot) files.
# https://macos-defaults.com/finder/appleshowallfiles.html
defaults write com.apple.finder AppleShowAllFiles -bool true
# Keep folders on top when sorting by name.
# https://macos-defaults.com/finder/_fxsortfoldersfirst.html
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Don't write .DS_Store files to network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Don't write .DS_Store files to USB volumes.
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Dock
###############################################################################

# Auto-hide the Dock.
# https://macos-defaults.com/dock/autohide.html
defaults write com.apple.dock autohide -bool true
# Don't rearrange Spaces based on most recent use.
# https://macos-defaults.com/mission-control/mru-spaces.html
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Apply changes
###############################################################################

for app in Finder Dock SystemUIServer; do
    killall "${app}" >/dev/null 2>&1 || true
done

echo "macOS defaults applied. Some changes require a logout/restart to take full effect."
