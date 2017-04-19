#! /bin/sh


## Description -----------

# Anti nsurlsessiond for macOS
# Looking for new 'nsurlsessiond' processus and killing it by getting his PID

# Made by Lucas Tarasconi
# 07/04/2017
# @Farnots

## Spinner function -----------

# Source of the function : http://fitnr.com/showing-a-bash-spinner.html

spinner()
{
	local pid=$!
	local delay=0.4
	local spinstr='|/-\'
	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		local temp=${spinstr#?}
		printf " [%c]  " "$spinstr"
		local spinstr=$temp${spinstr%"$temp"}
		sleep $delay
		printf "\b\b\b\b\b\b"
	done
	printf "    \b\b\b\b"
}


## Welcome pannel -----------


echo "+----------------------------------------+"
echo "| Starting annihilation of nsurlsessiond |"
echo "|        Made by Lucas Tarasconi         |"
echo "+----------------------------------------+"


## Testing verbose mode -----------

verbose=0
if [ $# -eq 1 ]; then
	if [ $1 == "-v" ]; then
		verbose=1
	fi
fi


## Removing the tempory file when exiting -----------

function quitting {
	echo "\n"
	echo "Removing tempory file"
	rm ./.nsurlsessiond
	echo "+----------------------------------------+"
	echo "| Stoping annihilation of nsurlsessiond  |"
	echo "+----------------------------------------+"
	exit 0
}

## Core of the script : kill all nsurlsession and show them -----------

function killIt {
	n=$(expr $line)
	sudo kill $n
}


function speaking {
	printf "\n"
	killIt
	current_time="`date +%H:%M:%S`"
	printf $current_time;
	printf " - killing nsurlsessiond number :  $n"
}

function killNsurl {
	pgrep -x nsurlsessiond>./.nsurlsessiond
	while read line ; do
		if [ $verbose -eq 1 ] ; then
			speaking
		else 
			killIt
		fi
	done <./.nsurlsessiond
	if [ $verbose -eq 1 ] ; then
		printf "\n"
		printf "Probing for new nsurlsessiond process"
	fi
}

## To avoid to use too many GPU just to kill processus -----------

function waiting {
	sleep 1
}

## While function -----------

trap "quitting" SIGTERM SIGINT
printf "Note : Password could be asked once to have the right to kill 'nsurlsessiond' \n"
if [ $verbose -eq 1 ] ; then
	printf "Probing for new nsurlsessiond process  "
else
	printf "Script is in progess ( '-v' to the verbose mode) : "
fi
sleep 1
while [[ 1 ]]; do
	pgrep -x nsurlsessiond>./.nsurlsessiond
	if [ $? -eq 0 ]; then
		killNsurl
	else
		waiting & spinner
	fi
	
done



