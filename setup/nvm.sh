#!/bin/sh

# Check for nvm
if test ! $(which nwm)
then
	echo "  => Installing nvm"
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash
fi