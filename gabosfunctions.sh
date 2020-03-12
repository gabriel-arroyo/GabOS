#!/bin/sh

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit;}

welcomemsg() { \
        dialog --title "Welcome!" --msgbox "Welcome to Luke's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured Linux desktop, which I use as my main machine.\\n\\n-Luke" 10 60
        }

getuserandpass() { \
        # Prompts user for new username an password.
        name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit
        while ! echo "$name" | grep "^[a-z_][a-z0-9_-]*$" >/dev/null 2>&1; do
                name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
        done
        pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
        pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
        while ! [ "$pass1" = "$pass2" ]; do
                unset pass2
                pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
                pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
        done ;}

preinstallmsg() { \
        dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
        }

refreshkeys() { \
        dialog --infobox "Refreshing Arch Keyring..." 4 40
        pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
        }

systembeepoff() { dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
        rmmod pcspkr
        echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf ;}

finalize(){ \
        dialog --infobox "Preparing welcome message..." 4 50
        echo "exec_always --no-startup-id notify-send -i ~/.local/share/larbs/larbs.png 'Welcome to LARBS:' 'Press Super+F1 for the manual.' -t 10000"  >> "/home/$name/.config/i3/config"
        dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t Luke" 12 80
        }

