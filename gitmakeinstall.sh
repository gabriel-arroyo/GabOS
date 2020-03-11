#!/bin/sh

dir=$(mktemp -d)
git clone --depth 1 "$1" "$dir" >/dev/null 2>&1
cd "$dir" || exit
make >/dev/null 2>&1
make install >/dev/null 2>&1
cd /tmp || return
