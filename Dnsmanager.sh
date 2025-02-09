#! /bin/bash

nameApp="Dnsmanager"
FileDnsName="ListDns.txt"

# ---- function bash. ----
function CreateFile () {
    echo "CreateFile"
    echo "-- list server Dns --" > ./ListDns.txt
    echo "Google;8.8.8.8;8.8.4.4" >> ./ListDns.txt
    echo "Cloudflare;1.1.1.1;1.0.0.1" >> ./ListDns.txt
    echo "OpenDNS;185.55.226.26;185.55.226.25" >> ./ListDns.txt
    echo "Neustar;156.154.70.5;156.154.71.5" >> ./ListDns.txt
    echo "SafeDNS;195.46.39.39;195.46.39.40" >> ./ListDns.txt
    echo "Shecan;178.22.122.100;185.51.200.2" >> ./ListDns.txt
    echo "Electro;78.157.42.100;78.157.42.101" >> ./ListDns.txt
    echo "RadarGame;10.202.10.10;10.202.10.11" >> ./ListDns.txt
    echo "Online403;10.202.10.102;10.202.10.202" >> ./ListDns.txt
    echo "Begzar;185.55.226.26;185.55.226.25" >> ./ListDns.txt
}
function loadFile () {
    echo "loadFile"
    for FILE in `find . -iname "$FileDnsName" -type f`
    do
        #Some function on the file
        FileDns=`cat ListDns.txt`  
        echo "$FileDns" 
        break
    done
}
function Filecheck(){
    loopn=$(find . -iname "$FileDnsName" -type f)
    if [[ $loopn == "" ]]; then
        CreateFile
    else
        loadFile
    fi
}

function Main () {
    Filecheck
    Sectionname="Main App"
	while true 
		do
			echo "--------------- Menu App ---------------"
            echo "Menu for $Sectionname
    1. Select Dns
    q. Quit "
			read -p "select in menu: " Selectmenu
			clear
			#Checking if variable is empty
			if test -z "$Selectmenu"; then
				echo "\$ input is null. input => ($Selectmenu)"
			else
				if [[ $Selectmenu =~ ^[0-9]+$ ]]; then
					#echo "${Selectmenu} is a number"
					if [ $Selectmenu == 1 ]; then
						echo "Select Dns"
					else
						echo "Number over list"
					fi

				else
					#echo "${NUM} is not a number"
					if [ "$Selectmenu" = "q" ] || [ "$Selectmenu" = "Q" ]; then
						echo "exit App $nameApp"
						exit
					elif [ "$Selectmenu" = "h" ] || [ "$Selectmenu" = "h" ]; then
						echo "Test help app "
					fi
				fi
			fi 
	# We can press Ctrl + C to exit the script
	done 
}

# ---- First run it in bash. ----
#echo "run command => chmod +x ./Dnsmanager.sh"
#Checking sudo access
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
else
    # Checking chmod file
    Main
fi

