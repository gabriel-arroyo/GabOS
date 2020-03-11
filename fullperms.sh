#!/bin/bash

sed -i "/#GabOS/d" /etc/sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL #GabOS" >> /etc/sudoers

