#!/bin/sh

### Variables ###
thispath=$(dirname "$0")
dotfilesrepo="https://github.com/gabriel-arroyo/gabosconfig.git"
name="gabo"
pass="justLove.7"
edition="bspwm"

### Imports ###

[ -f $thispath/gabosfunctions.sh ] && . $thispath/gabosfunctions.sh

./pacinstall.sh dialog || error "Are you sure you're running this as the root user and have an internet connection?"

welcomemsg || error "User exited."
preinstallmsg || error "User exited."

# Create user and give permissions for installing
#getuserandpass || error "User exited"
./createuser.sh -n "$name" -p "$pass" || error "Error adding username and/or password."
./fullperms.sh

# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Install tools
dialog --title "GabOS Installation" --infobox "Installing \`basedevel\` and \`git\` for installing other software." 5 70
./pacinstall.sh base-devel
./pacinstall.sh git
[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case
./aurmanualinstall.sh yay

# Make pacman and yay colorful and adds eye candy on the progress bar because why not.
grep "^Color" /etc/pacman.conf >/dev/null || sed -i "s/^#Color/Color/" /etc/pacman.conf
grep "ILoveCandy" /etc/pacman.conf >/dev/null || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# ----------- Instalation ------------
./installall.sh
# ----------- Config Files -----------
./putconfigfiles.sh gabo "$dotfilesrepo"
rm -f "/home/$name/README.md" "/home/$name/LICENSE"

systembeepoff

# Return to normal permissions
./adminperms.sh

# Make zsh the default shell for the user
sed -i "s/^$name:\(.*\):\/bin\/.*/$name:\1:\/bin\/zsh/" /etc/passwd

# dbus UUID must be generated for Artix runit
dbus-uuidgen > /var/lib/dbus/machine-id

# Let GabOS know the WM it's supposed to run.
echo "$edition" > "/home/$name/.local/share/gabos/wm"; chown "$name:wheel" "/home/$name/.local/share/gabos/wm"

# Last message! Install complete!
finalize


