#! /bin/bash
nameApp="Dnsmanager"
# ---- function bash. ----
function Main () {
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
						echo "exit $nameApp"
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
echo "run command => chmod +x ./$me"
#Checking sudo access
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
else
  # Checking chmod file
    Main
  fi
fi

