#!/usr/bin/env bash

ipr=$1
cidr=$2

echo -e "###################################################\n"
echo -e "####		The grand and powerful				####\n"
echo -e "####		Glowing Octo Lana!					####\n"
echo -e "####											####\n"
echo -e "####	Watcher of all, finder of...things?		####\n"
echo -e "###################################################\n"

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
	nmap -sS -sC -sV -O --min-rate=400 --min-parallelism=512 -p- -n -Pn -PS -A --open $host >> $host.txt
	samrdump2 $host >> $host.txt
	snmpcheck -t $host >> $host.txt
	onesixtyone $host >> $host.txt
	snmpwalk -c public -v1 $host >> $host.txt
	enum4linux $host >> $host.txt
done < $ipr.txt

cd ..
chown -hR $whoami:$whoami /u $ipr
cd $ipr

echo -e "Making a list of HTTP servers for the screenshoting...\n"

grep "80/tcp\|8000/tcp\|443/tcp\|8443/tcp\|8080/tcp" *.txt > webservers.txt && cat webservers.txt | cut -d "/" -f1 | sed 's/.txt//' > eyewitness.lst

while read host;do
	dirbuster-ng $host >> $host.txt
done < eyewitness.lst

eyeWitness --no-dns -f eyewitness.lst -d /tmp/$ipr\_webservers

cp /tmp/$ipr\_webservers ./$ipr\_webservers

chown -hR $whoami:$whoami /u ./$ipr\_webservers

grep "22/tcp" *.txt >> ssh_service.txt && cat ssh_service.txt | cut -d "/" -f1 | sed -d "/" -f1 | sed 's/.txt//' > ssh_service_cleaned.txt

while read bruteme;do
	#hydra -L ./name.lst -P ./pass.lst ssh://$bruteme >> $bruteme.txt
done < ssh_service_cleaned.txt


# Dumping ground for random ideas.
# ================================
#
#
# grep "25/tcp" *.txt > smtp_servers.txt
#
# echo "slmail" | { read test; searchsploit $test; }
#
#
