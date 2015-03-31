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
mv $ipr\_cleaned.txt $ipr.txt

echo -e "Creating a mess of files...\n"

while read host;do touch $host.txt;done < $ipr.txt

while read host;do grep $host $ipr.txt;done < $ipr.txt >> $host.txt

echo -e "Now we enum...\n"

while read host;do
	echo -e "Scanning $host\n"
	nmap -sS -sC -sV -O --min-rate=400 --min-parallelism=512 -p1-65535 -n -Pn -PS --open $host >> $host.txt 
	snmpcheck-nothink -t $host >> $host.txt
	enum4linux $host >> $host.txt
done < $ipr.txt

cd ..
chown -hR $whoami:$whoami /u $ipr
cd $ipr

echo -e "Making a list of HTTP servers for the screenshoting...\n"

grep "80/tcp\|8000/tcp\|443/tcp\|8443/tcp\|8080/tcp" *.txt > webservers.txt && cat webservers.txt | cut -d "/" -f1 | sed 's/.txt//' > eyewitness.lst

EyeWitness.py --no-dns -f eyewitness.lst -d /tmp/$ipr\_webservers

cp /tmp/$ipr\_webservers ./$ipr\_webservers

chown -hR $whoami:$whoami /u ./$ipr\_webservers

# Dumping ground for random ideas.
# ================================
# 
# 
# grep "25/tcp" *.txt > smtp_servers.txt
# 
# echo "slmail" | { read test; searchsploit $test; }
# 
# 
