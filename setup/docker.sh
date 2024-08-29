#!/bin/bash

PREFIX="\e[1;34m[#]"
SUFFIX="\e[0m"

# Install docker engine

# 1. Optionally remove any existing conflicting packages
echo -en "$PREFIX Do you want to remove any existing docker packages? [y/N]: $SUFFIX"
read response
response=${response,,}  # Convert to lowercase
if [[ "$response" == "y" || "$response" == "yes" ]]; then
	echo -e "$PREFIX Performing the action...$SUFFIX"
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc;
		do sudo apt-get remove $pkg;
	done
else
	echo -e "$PREFIX Not removing packages, continuing...$SUFFIX"
fi

# 2. Add docker gpg key
if [ -f "/etc/apt/keyrings/docker.asc" ]; then
	echo -e "$PREFIX Docker keyring exists.$SUFFIX"
else
	echo -e "$PREFIX Adding docker keyring.$SUFFIX"
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

# 3. Add the repository to Apt sources:
if [ -f "/etc/apt/sources.list.d/docker.list" ]; then
	echo -e "$PREFIX Docker source already exists.$SUFFIX"
else
	echo -e "$PREFIX Adding docker source.$SUFFIX"
        echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
fi

# 4. Install latest docker
echo -e "$PREFIX Installing docker.$SUFFIX"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Create docker group if doesn't exist
DOCKER_GROUP="docker"
if getent group "$DOCKER_GROUP" > /dev/null 2>&1; then
    echo -e "$PREFIX Group '$DOCKER_GROUP' already exists.$SUFFIX"
else
    # Create the group if it does not exist
    sudo groupadd "$DOCKER_GROUP"
    echo -e "$PREFIX Group '$DOCKER_GROUP' has been created.$SUFFIX"
fi

# 6. Add current user to the docker group if they are not already part of it
if id -nG "$USER" | grep -qw "$DOCKER_GROUP"; then
	echo -e "$PREFIX User '$USER' is already a member of group '$DOCKER_GROUP'.$SUFFIX"
else
        # Add the user to the group
	sudo usermod -aG "$GROUP_NAME" "$USER"
	echo -e "$PREFIX User '$USER' has been added to group '$GROUP_NAME'.$SUFFIX"
fi	

echo -e "$PREFIX Done!$SUFFIX"
echo -e "$PREFIX Please relog to propagate group changes, or use 'newgrp docker' to temporarily inform the current shell"
