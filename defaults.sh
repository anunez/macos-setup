#!/bin/sh

#############################
# Set macOS custom defaults #
#############################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

echo "Spotlight: Disable indexing for any volume that gets mounted and has not yet been indexed before"
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

echo "Global: Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Global: Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Global: Save to disk, rather than iCloud, by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "PrintingPrefs: Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "LaunchServices: Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "ImageCapture: Prevent Photos from opening automatically when devices are plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Untested
echo "systempreferences: Disable resume system-wide"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

echo "CrashReporter: Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

# Untested
echo "Global: Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

# Untested
echo "Global: Set standby delay to 24 hours (default is 1 hour)"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
sudo pmset -a standbydelay 86400

# echo "Mouse: Enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Global: Stop iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

echo "Global: Disable press-and-hold for special keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Global: Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# echo "Global: Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Global: Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

#
# Finder
#

echo "Finder: Set HOME as the default location for new Finder windows"
# For Desktop use PfDe, for other paths use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo "Finder: Show icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "Finder: Show hidden files in Finder by default"
defaults write com.apple.Finder AppleShowAllFiles -bool true

echo "Finder: Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Finder: Show status bar by default"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Finder: Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "Finder: Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "Finder: Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "Finder: When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Finder: Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Finder: Use list view in all windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "Finder: Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "Finder: Allow text selection in Quick Look/Preview by default"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "Finder: Expand the following File Info panes: General, Open with, and Sharing & Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true

echo "Finder: Avoid creating .DS_Store files on network and USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Finder: Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Finder: Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo "Finder: Show the ~/Library folder"
chflags nohidden ~/Library

echo "Finder: Show the /Volumes folder"
sudo chflags nohidden /Volumes

#
# Time Machine
#

echo "Time Machine: Prevent from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Time Machine: Disable local backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal

#
# Activty Monitor
#

echo "Activity Monitor: Show the main window when launching"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "Activity Monitor: Show all processes"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "Activity Monitor: Sort results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

#
# TextEdit
#

echo "TextEdit: Use plain text mode for new documents"
defaults write com.apple.TextEdit RichText -int 0

echo "TextEdit: Open and save files as UTF-8"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

#
# Google Chrome
#

echo "Google Chrome: Disable the all too sensitive backswipe on trackpads"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo "Google Chrome: Disable the all too sensitive backswipe on Magic Mouse"
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

echo "Google Chrome: Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

echo "Google Chrome: Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

#
# Transmission
#

echo "Transmission: Set up an incomplete downloads folder in Downloads"
mkdir -p ~/Downloads/Incomplete
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete"

echo "Transmission: Set auto-add folder to be Downloads"
defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"

echo "Transmission: Don't prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

echo "Transmission: Trash original torrent files after adding them"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo "Transmission: Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo "Transmission: Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

echo "Transmission: Auto-resize the window to fit transfers"
defaults write org.m0k.transmission AutoSize -bool true

echo "Transmission: Set up the best block list"
defaults write org.m0k.transmission EncryptionRequire -bool true
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"

echo "Restarting affected apps"
for app in \
  "Activity Monitor" \
  "cfprefsd" \
  "Dock" \
  "Finder" \
  "Google Chrome" \
  "SystemUIServer" \
  "TextEdit" \
  "Transmission"; do
  killall "${app}" > /dev/null 2>&1
done