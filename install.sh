#!/bin/sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#
# Computer name
#

echo "Name your computer:"
read COMPUTER_NAME
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

#
# brew
#

echo "Installing Homebrew"
echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Disabling Homebrew analytics"
brew analytics off

echo "Installing command line utilities from Homebrew"
brew install \
  git \
  htop \
  nmap \
  node \
  python \
  ruby \
  tree \
  vim \
  wget \
  yarn \

echo "Installing macOS apps from Homebrew Cask"
brew cask install \
  docker \
  dropbox \
  flux \
  google-chrome \
  iterm2 \
  java \
  mplayerx \
  sketch \
  slack \
  spectacle \
  spotify \
  steam \
  telegram \
  the-unarchiver \
  visual-studio-code \

echo "Cleaning up Homebrew cache"
brew cleanup
brew cask cleanup

#
# ruby
#

echo "Upgrading ruby gems"
gem update

#
# python
#

echo "Upgrading pip"
pip install --upgrade pip setuptools

#
# git
#

echo "Enter your git user name:"
read GIT_USER_NAME
git config --global user.name "${GIT_USER_NAME}"

echo "Enter your git user email:"
read GIT_USER_EMAIL
git config --global user.email "${GIT_USER_EMAIL}"

echo "Git: Rebase by default when doing git pull"
git config --global pull.rebase true

echo "Git: Enable colored output by default"
git config --global color.ui true

#
# zsh
#

echo "Setting up zsh shell with oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)
