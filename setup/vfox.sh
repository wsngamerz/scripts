#!/bin/bash

PREFIX="\e[1;34m[#]"
SUFFIX="\e[0m"

# 1. Add the repository to apt sources:
if [ -f "/etc/apt/sources.list.d/versionfox.list" ]; then
        echo -e "$PREFIX Vfox source already exists.$SUFFIX"
else
        echo -e "$PREFIX Adding vfox source.$SUFFIX"
	echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | sudo tee /etc/apt/sources.list.d/versionfox.list
        sudo apt-get update
fi

# 2. Install vfox
echo -e "$PREFIX Installing vfox. $SUFFIX"
sudo apt-get install vfox

# 3. Activate vfox by adding to bashrc (if needed)
if grep -Fxq 'eval "$(vfox activate bash)"' ~/.bashrc; then
	echo -e "$PREFIX Already active in .bashrc $SUFFIX"
else
	echo -e "$PREFIX Adding to .bashrc $SUFFIX"
	echo 'eval "$(vfox activate bash)"' >> ~/.bashrc
	source ~/.bashrc
fi

# 4. Install nodejs and golang plugins
echo -e "$PREFIX Installing plugins.$SUFFIX"
vfox add nodejs
vfox add golang

# 5. Install latest runtimesi
echo -e "$PREFIX Installing latest runtimes.$SUFFIX"
vfox install nodejs@latest
vfox install golang@latest

echo -e "$PREFIX Remember to set current global runtimes after sourcing/restarting shell.$SUFFIX"
echo -e "$PREFIX - 'vfox use -g nodejs'$SUFFIX"
echo -e "$PREFIX - 'vfox use -g golang'$SUFFIX"
echo -e "$PREFIX Done!$SUFFIX"
