#!/bin/bash

loadkeys la-latin1

echo "-----------Pinging-----------"
ping -c 3 google.com

timedatectl set-ntp true

echo "Creating partitions"

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +512M # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +15360M  # default, extend partition to end of disk
  n # new partition
  p # primary partition
  3 # partion number 2
    # default, start immediately after preceding partition
  +20480M  # default, extend partition to end of disk
  n # new partition
  p # primary partition
  1 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

lsblk

echo "-----------Formatting-----------"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4

echo "-----------Make swap-----------"
mkswap /dev/sda2
swapon /dev/sda2

echo "-----------Mounting-----------"
mount /dev/sda3 /mnt
mkdir /mnt/home
mount /dev/sda4/ /mnt/home

lsblk

echo "-----------Installing Linux -----------"
pacstrap -i /mnt base base-devel linux linux-firmware vim netctl dhcpcd wpa_supplicant dialog git

genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt/bin/bash


