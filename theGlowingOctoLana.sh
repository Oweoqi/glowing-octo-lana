#!/bin/bash

ipr=$1
cidr=$2

if [ "$ipr" == "" ] || [ "$cidr" == "" ]
then
echo -e "No SUBNET or CIDR was entered, please re-run with: ./theGlowingOctoLana.sh <SUBNET> <CIDR> \n"
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

echo -e "Cleaning up the list...\n"

cat ./$ipr.txt | cut -d " " -f2 | sed '/Nmap/d' > $ipr\_cleaned.txt

echo -e "Creating a mess of files...\n"

while read host;do touch $host.txt;done < $ipr\_cleaned.txt

while read host;do grep $host $ipr.txt;done < $ipr\_cleaned.txt >> $host.txt

echo -e "Now we enum...\n"

while read host;do nmap -sS -sC -sV --min-rate=400 
--min-parallelism=512 -p1-65535 -n -Pn -PS --open $host >> $host.txt; 
snmpcheck -t $host 
>> $host.txt; enum4linux $host >> $host.txt;done < $ipr\_cleaned.txt

