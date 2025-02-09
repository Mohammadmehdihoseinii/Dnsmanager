#! /bin/bash

nameApp="Dnsmanager"
FileDnsName="ListDns.txt"

# ---- function bash. ----
function CreateFile () {
    echo "CreateFile"
    echo "-- list server Dns --" > ./ListDns.txt

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

