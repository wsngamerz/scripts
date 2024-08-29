#!/bin/bash

URL="https://discord.com/api/download?platform=linux&format=deb"
OUTPUT_FILE="./discord.deb"
PREFIX="\e[1;34m[#]"
SUFFIX="\e[0m"

# 1. Download the file using curl
echo -e "$PREFIX Downloading discord.$SUFFIX"
curl -L -o "$OUTPUT_FILE" "$URL"

# 2. Check if the download was successful
if [ $? -ne 0 ]; then
    echo -e "$PREFIX Failed to download the file.$SUFFIX"
    exit 1
fi

# 3. Install the package using apt
echo -e "$PREFIX Installing discord.$SUFFIX"
sudo apt install "$OUTPUT_FILE"

# Check if the installation was successful
if [ $? -ne 0 ]; then
	echo -e "$PREFIX Failed to install the package.$SUFFIX"
else
	echo -e "$PREFIX Note that a message such as 'N: Download is performed unsandboxed as root...' still means a successful install :)$SUFFIX"
fi

# Clean up by removing the downloaded file
echo -e "$PREFIX Cleaning up.$SUFFIX"
rm "$OUTPUT_FILE"

echo -e "$PREFIX Done!$SUFFIX"

