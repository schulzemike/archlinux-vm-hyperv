#!/bin/bash

source /vagrant/provision/helper.sh

echo
echo "###################################################################"
echo
echo "Installing tools for user $USER_NAME"
echo

[[ -z "${USER_NAME}" ]] && echo "No USER_NAME has been provided. Skipping tool installation." && exit 0

USER_HOME=/home/$USER_NAME

packages=(
  docker
  docker-compose
  firefox
  jq
  # libappindicator is required to display the trayicon of the jetbrains-toolbox
  libappindicator-gtk3
  keepassxc
  net-tools
  org-xrandr
  # libreoffice-still
  task
  # terraform
)

aur_packages=(
  google-chrome 
  jetbrains-toolbox
  noto-fonts-emoji
  nvm
)
echo
echo
echo "#######################################################################"
echo "Configuring JetBrains Toolbox"
sudo mkdir -p $USER_HOME/.local/share/JetBrains
sudo mkdir -p $USER_HOME/.local/share/JetBrains/Toolbox/apps
sudo mkdir -p $USER_HOME/.local/share/JetBrains/Toolbox/scripts
sudo chown -R $USER_NAME:$USER_NAME $USER_HOME/.local



installPackages "${packages[@]}"
installAurPackages "${aur_packages[@]}"


echo
echo
echo "#######################################################################"
echo "Configuring docker"
sudo /usr/bin/systemctl enable docker.service
sudo usermod -aG docker $USER_NAME

