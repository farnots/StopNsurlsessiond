#! /bin/sh


## Description

# Anti nsurlsessiond for macOS
# Looking for new 'nsurlsessiond' processus and killing it by getting his PID

# Made by Lucas Tarasconi
# 07/04/2017
# @Farnots

## Welcome pannel

echo "+----------------------------------------+"
echo "| Starting annihilation of nsurlsessiond |"
echo "|        Made by Lucas Tarasconi         |"
echo "+----------------------------------------+"


function quitting {
	echo "\n"
	echo "Removing tempory file"
	rm ./.nsurlsessiond
	echo "+----------------------------------------+"
	echo "| Stoping annihilation of nsurlsessiond  |"
	echo "+----------------------------------------+"
	exit 0
}


trap "quitting" SIGTERM SIGINT

while [[ 1 ]]; do
	echo "... Probing for new nsurlsessiond process ..."
	pgrep -x nsurlsessiond>./.nsurlsessiond
	while read line ; do
           n=$(expr $line)
           echo "killing nsurlsessiond number :  $n"
           sudo kill $n
    done <./.nsurlsessiond
	sleep 1;
done



