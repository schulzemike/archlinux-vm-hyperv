#!/bin/bash
#
# NOTICE: The username has to be provided as a Environment variable 
#
echo -e "\n###################################################################"
echo
echo "Creating user"
echo

[[ -z "${USER_NAME}" ]] && echo "No USER_NAME has been provided. Skipping user creation." && exit 0

HOME_DIR="/home/$USER_NAME"


if id $USER_NAME >/dev/null 2>&1; then
    echo "User $USER_NAME has already been created"
else 
    /usr/bin/useradd --create-home --user-group $USER_NAME
    echo -e 'changeme\nchangeme' | /usr/bin/passwd $USER_NAME
	
	echo "$USER_NAME ALL=(ALL) NOPASSWD: /usr/bin/systemctl poweroff,/usr/bin/systemctl halt,/usr/bin/systemctl reboot" >> /etc/sudoers.d/10_$USER_NAME
	
	mkdir -p $HOME_DIR/.cache
	mkdir -p $HOME_DIR/.config
	mkdir -p $HOME_DIR/.local
	chown -R $USER_NAME:$USER_NAME $HOME_DIR
	
	echo -e "Finished creating user: $USER_NAME\n"
fi 
