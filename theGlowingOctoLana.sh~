#!/bin/bash

ipr=$1
cidr=$2

if [ "$ipr" == "" ] || [ "$cidr" == "" ]
then
echo "No SUBNET or CIDR was entered, please re-run with: ./theGlowingOctoLana.sh <SUBNET> <CIDR>"
exit
fi

# Check to ensure the script is run as root/sudo
if [ "$(id -u)" != "0" ]; 
then
echo "This script must be run as root. Later hater." 1>&2
exit 1
fi

mkdir $ipr
cd $ipr

nmap -sP $ipr/$cidr -oG $ipr.txt

echo "Cleaning up the list...\n"

cat ./$ipr.txt | cut -d " " -f2 > $ipr\_cleaned.txt

echo "Creating a mess of files...\n"

while read host;do touch $host.txt;done < $ipr\_cleaned.txt

while read host;do grep $host $ipr.txt;done < $ipr\_cleaned.txt >> $host.txt

echo "Now we enum...\n"

while read host;do nmap -sV $host >> $host.txt; snmpcheck -t $host >> $host.txt; enum4linux $host >> $host.txt;done < $ipr\_cleaned.txt

