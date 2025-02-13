#!/bin/bash

source /vagrant/provision/helper.sh

echo
echo "###################################################################"
echo
echo "Installing qtile"
echo

packages=(
  qtile
  rofi
  sxhkd
  xclip
  xsel
)

aur_packages=(
#  archlinux-logout-git
#  arcolinux-wallpapers-git
  qtile-extras
#  sddm-theme-tokyo-night
)
# trust the gpg key of the qtile-extras provider 
# add it to the vagrant user that is used to install the AUR packages with pikaur
gpg --recv-keys 58A9AA7C86727DF7


installPackages "${packages[@]}"
installAurPackages "${aur_packages[@]}"


#
# qtile adjustments
#

# remove the wayland session from the sddm launcher
sudo rm /usr/share/wayland-sessions/qtile-wayland.desktop 2>/dev/null

# start qtile with a custom config. the standard config will be used in case the custom one is broken or missing
sudo sed -i -z "s/qtile start\n/qtile start -c \".config\/qtile\/myconfig.py\"\n/" /usr/share/xsessions/qtile.desktop

# set qtile to the .xinitrc of the vagrant user, so that it starts when the connection is established via xrdp
configureXrdpDesktopForUser vagrant


# 
# Set the XDG environment variables system wide
# Hint: putting EOT in quotes prevents the variable evaluation, which is
#       what we want here
#
sudo tee /etc/profile.d/0000-xdg-dirs.sh <<'EOT'
#!/bin/sh

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
EOT

echo -e "Installation of qtile finished.\n"