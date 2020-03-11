#!/bin/sh

cd /tmp || exit
rm -rf /tmp/"$1"*
curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
cd "$1" &&
sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
cd /tmp || return
