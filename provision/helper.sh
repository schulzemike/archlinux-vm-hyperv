#!/bin/bash


function installPackages {
	packages=("$@")

    echo
	echo "--------------------------------------------------------"
	echo "Installing packages ..."
	
	sudo /usr/bin/pacman -S --noconfirm --needed "${packages[@]}"
	
	echo
}


function installAurPackages {
	aur_packages=("$@")
	
    USER_ID=$(id -u vagrant)

    echo
	echo "--------------------------------------------------------"
	echo "Installing aur packages with the vagrant user: $USER_ID"

    pikaur -S --noconfirm --needed "${aur_packages[@]}"

	echo
}



function configureXrdpDesktopForUser {
	USER=$1

	if [[ ! -e /home/$USER/.xinitrc ]]; then
		echo "Configuring Xrdp Desktop for user: $USER_NAME"
		echo "exec qtile start -c .config/qtile/myconfig.py" | sudo tee /home/$USER/.xinitrc
		sudo chown $USER:$USER /home/$USER/.xinitrc
	fi
}