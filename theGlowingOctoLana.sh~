#!/bin/bash

ipr=$1
cidr=$2

mkdir $ipr
cd $ipr

sudo nmap -sP $ipr/$cidr -oG $ipr.txt

echo "Cleaning up the list...\n"

cat ./$ipr.txt | cat -d " " -f2 > $ipr\_cleaned.txt

echo "Creating a mess of files...\n"

while read host;do touch $host.txt;done < $ipr\_cleaned.txt

while read host;do grep $host $ipr.txt;done < $ipr\_cleaned.txt >> $host.txt

echo "Now we enum...\n"

while read host;snmpcheck -t $host >> $host.txt; enum4linux $host >> $host.txt;done < $1

