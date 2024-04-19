#!/bin/bash

# Installer can only be executed once.
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run with sudo or as root."
  exit 1
fi

read -rsn1 -p"Install Pre-Requisites - press any key to continue";echo
apt install apt-transport-https ca-certificates gnupg2 software-properties-common -y

read -rsn1 -p"Download the GPG Key - press any key to continue";echo
curl -fsSL https://download.docker.com/linux/debian/gpg -o docker.gpg

read -rsn1 -p"Add the Key to Your Trusted Keys Directory - press any key to continue";echo
gpg --no-default-keyring --keyring /usr/share/keyrings/docker-archive-keyring.gpg --import docker.gpg
rm docker.gpg

read -rsn1 -p"Set Up the Docker Repository - press any key to continue";echo
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

read -rsn1 -p"Update and Install Docker - press any key to continue";echo
apt update
apt install docker-ce docker-ce-cli containerd.io -y
usermod -aG docker admin

read -rsn1 -p"Install T-Pot - press any key to continue";echo
cd iso/installer
./install.sh "$@"
