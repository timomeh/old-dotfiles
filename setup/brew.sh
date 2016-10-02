#!/bin/sh

# Check for Homebrew
if test ! $(which brew)
then
	echo "  => Installing Homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	echo "  => Install antibody"
	brew tap getantibody/homebrew-antibody
	brew install antibody

	echo "  => Install rmtree"
	brew tap beeftornado/rmtree
	brew install beeftornado/rmtree/brew-rmtree

	echo "  => Install zsh"
	brew install zsh
	brew install zsh-completions

	echo "  => Install fzf"
	brew install fzf
	/usr/local/opt/fzf/install
fi
