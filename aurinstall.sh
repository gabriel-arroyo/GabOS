#!/bin/sh

while getopts ":t:" opt; do
  case ${opt} in
    u )
      name=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done

[ -z $name ] && name="gabo"


sudo -u "$name" yay -S --noconfirm "$1" >/dev/null 2>&1
