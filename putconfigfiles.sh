#!/bin/bash

name=$1
repo=$2

 # Downlods a gitrepo $2 and places the files in $1 only overwriting conflicts
dialog --infobox "Downloading and installing config files..." 4 60
dir=$(mktemp -d)
[ ! -d "/home/$name" ] && mkdir -p "/home/$name" && chown -R "$name:wheel" "/home/$name"
chown -R "$name:wheel" "$dir"
sudo -u "$name" git clone -b master --depth 1 "$repo" "$dir/gitrepo" >/dev/null 2>&1 &&
sudo -u "$name" cp -rfT "$dir/gitrepo" "/home/$name"

