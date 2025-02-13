#!/bin/bash
echo -e "\n###################################################################"
echo
echo "Configuring user and loading personal dotfiles"
echo

[[ -z "$USER_NAME" || -z "$USER_EMAIL" ]] && echo "No USER_NAME or USER_EMAIL have been provided. Skipping user configuration." && exit 0
[[ -z "$FULL_NAME" || -z "$DOTFILES_REPO" ]] && echo "No FULL_NAME or DOTFILES_REPO have been provided. Skipping user configuration." && exit 0

HOME_DIR="/home/$USER_NAME"
RSA_KEY="$HOME_DIR/.ssh/id-github_rsa"


if [[ ! -e "${HOME_DIR}/.ssh" ]]; then
 	mkdir $HOME_DIR/.ssh

    # echo "Creating GitHub RSA Key..."
	# /usr/bin/ssh-keygen -t ed25519 -C $USER_EMAIL -f $RSA_KEY -N ""
	
	echo "Using provided GitHub RSA Key..."
	cp /vagrant/ssh/id-github_rsa $RSA_KEY
	chmod 600 $RSA_KEY
	
	echo -e "Host github.com\n    IdentityFile $RSA_KEY" >> $HOME_DIR/.ssh/config
	/usr/bin/ssh-keyscan github.com >> $HOME_DIR/.ssh/known_hosts
	chown -R $USER_NAME:$USER_NAME $HOME_DIR/.ssh
	chmod 700 $HOME_DIR/.ssh
fi

# 
echo "exec qtile start -c \".config/qtile/myconfig.py\"" > $HOME_DIR/.xinitrc
chown -R $USER_NAME:$USER_NAME $HOME_DIR/.ssh

# Initialize the .dotfiles repo as the created user - see: https://wiki.archlinux.org/title/Dotfiles
GIT_DIR=$HOME_DIR/.dotfiles

if [[ ! -d $GIT_DIR ]]; then
	su -c "/usr/bin/git init --initial-branch=main --bare $GIT_DIR" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR config status.showUntrackedFiles no" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR config user.email $USER_EMAIL" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR config user.name $FULL_NAME" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR remote add origin $DOTFILES_REPO" $USER_NAME
	su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR fetch" $USER_NAME
    su -c "/usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME_DIR checkout main --force" $USER_NAME
fi

# Adding the permanent mount for projekte drive
[[ -e $HOME_DIR/projekte ]] || (mkdir -p $HOME_DIR/projekte && chown -R $USER_NAME:$USER_NAME $HOME_DIR/projekte && echo "Created projekte folder")
[[ $(grep sdb1 /etc/fstab) ]] || (echo "/dev/sdb1	/home/$USER_NAME/projekte	ext4	defaults	0		2" >> /etc/fstab && echo "Added fstab entry for projekte drive")

echo -e "Finished configuring the user\n"
