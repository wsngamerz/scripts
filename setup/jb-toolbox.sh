#!/bin/bash

RELEASE_URL="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
TMP_DOWNLOAD="/tmp/jetbrains-toolbox.tgz"
TMP_EXTRACT="/tmp/jetbrains-toolbox-ex"
PREFIX="\e[1;34m[#]"
SUFFIX="\e[0m"

# 0. Install libfuse2
echo -e "$PREFIX Ensuring libfuse2 is installed.$SUFFIX"
sudo apt-get update
sudo apt-get install libfuse2

# 1. Get download url from releases
echo -e "$PREFIX Getting download url.$SUFFIX"
DOWNLOAD_URL=$(curl --silent $RELEASE_URL | jq --raw-output '.TBA[0].downloads.linux.link')

# 2. Downloading toolbox
echo -e "$PREFIX Downloading ($DOWNLOAD_URL).$SUFFIX"
curl --output $TMP_DOWNLOAD --progress-bar --location $DOWNLOAD_URL

# 3. Check if the download was successful
if [ $? -ne 0 ]; then
    echo -e "$PREFIX Failed to download the file.$SUFFIX"
    exit 1
fi

# 4. Extract
echo -e "$PREFIX Extracting tar.gz.$SUFFIX"
mkdir -p $TMP_EXTRACT
tar -xzf $TMP_DOWNLOAD -C $TMP_EXTRACT

# 5. Install executable
echo -e "$PREFIX Executing 'jetbrains-toolbox'.$SUFFIX"
cd $TMP_EXTRACT/jetbrains-toolbox-*/
./jetbrains-toolbox

# Clean up tmp
echo -e "$PREFIX Cleaning up.$SUFFIX"
rm -rf "$TMP_EXTRACT" "$TMP_DOWNLOAD"

echo -e "$PREFIX Done!$SUFFIX"

