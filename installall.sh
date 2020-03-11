#!/bin/bash

grepseq="\"^[PGA]*,\""
progsfile=progs.cvs
([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' | eval grep "$grepseq" > /tmp/progs.csv
total=$(wc -l < /tmp/progs.csv)
aurinstalled=$(pacman -Qqm)
while IFS=, read -r tag program comment; do
        n=$((n+1))
	echo "$n de $total"
        echo "$comment" | grep "^\".*\"$" >/dev/null 2>&1 && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
        case "$tag" in
	        "A") ./aurinstall.sh "$program" "$comment" ;;
                "G") ./gitmakeinstall.sh "$program" "$comment" ;;
                "P") ./pipinstall.sh "$program" "$comment" ;;
                *) ./pacinstall.sh "$program" "$comment" ;;
        esac
done < /tmp/progs.csv
