#!/bin/bash

source /vagrant/provision/helper.sh

echo
echo "###################################################################"
echo
echo "Installing the terminal emulator"
echo


function downloadNerdFont() {

    NERD_FONTS_VERSION="v3.3.0"
	SYSTEM_FONT_DIR="/usr/local/share/fonts"
	
	if [[ $# -ne 1 ]]; then
		echo "Provide the name of the font" >&2
		exit 1
	fi

	sudo mkdir -p $SYSTEM_FONT_DIR
	
	FONT=$1
		
	if [[ ! -d $SYSTEM_FONT_DIR/$FONT ]]; then
		wget -q -O /$HOME/$FONT.zip https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$FONT.zip && sudo unzip -q -d $SYSTEM_FONT_DIR/$FONT /$HOME/$FONT.zip && rm /$HOME/$FONT.zip
		if [[ $? -ne 0 ]]; then
			echo "Could not download the font: $FONT" >&2
			exit 1
		fi
		echo "Successfully installed the font: $FONT"
	fi
	return 0
}


packages=(
  alacritty
  fastfetch
  starship
  unzip
#  ttf-dejavu
)

installPackages "${packages[@]}"

#
# Fonts
#
downloadNerdFont "JetBrainsMono"
downloadNerdFont "Noto"



