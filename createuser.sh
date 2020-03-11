#!/bin/sh

while getopts ":n:p:" opt; do
  case ${opt} in
    n )
      name=$OPTARG
      ;;
    p )
      pass=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done

[ -z "$name" ] && echo "name missing, use -n opt" && exit
[ -z "$pass" ] && echo "pass missing, use -p opt" && exit

echo "Adding user.."
useradd -m -g wheel -s /bin/bash "$name" >/dev/null 2>&1 ||
echo "Group and home.."
usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
echo "Changing pass.."
echo "$name:$pass" | chpasswd

