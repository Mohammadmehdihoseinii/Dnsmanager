#! /bin/bash

nameApp="Dnsmanager"
FileDnsName="ListDns.txt"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIRFile="$DIR/$nameApp"
declare -A List_Server=()
# ---- function bash. ----
# ---- strat:Folder. ----
function createdata(){   
    function CreatetextDns () {
        if [ -f "/$DIRFile/ListDns.txt" ]; then
            echo "File found!"
        else   
            echo "#list-server-Dns" > /$DIRFile/ListDns.txt
            echo "Google;8.8.8.8;8.8.4.4" >> /$DIRFile/ListDns.txt
            echo "Cloudflare;1.1.1.1;1.0.0.1" >> /$DIRFile/ListDns.txt
            echo "OpenDNS;185.55.226.26;185.55.226.25" >> /$DIRFile/ListDns.txt
            echo "Neustar;156.154.70.5;156.154.71.5" >> /$DIRFile/ListDns.txt
            echo "SafeDNS;195.46.39.39;195.46.39.40" >> /$DIRFile/ListDns.txt
            echo "Shecan;178.22.122.100;185.51.200.2" >> /$DIRFile/ListDns.txt
            echo "Electro;78.157.42.100;78.157.42.101" >> /$DIRFile/ListDns.txt
            echo "RadarGame;10.202.10.10;10.202.10.11" >> /$DIRFile/ListDns.txt
            echo "Online403;10.202.10.102;10.202.10.202" >> /$DIRFile/ListDns.txt
            echo "Begzar;185.55.226.26;185.55.226.25" >> /$DIRFile/ListDns.txt
            #append log
            echo "Create db Dns " >> /$DIRFile/log.txt
        fi
        loadFile
    }
    function createtextlog() {
        if [ -f "/$DIRFile/log.txt" ]; then
            echo "File found!"
        else
            echo "app = '$nameApp v1'" > /$DIRFile/log.txt
        fi
    }
    function createFolder() {
        #! echo "$DIR"
        if [ -d "/$DIRFile" ]; then
            echo "Directory found"
        else
            mkdir -m 777 /$DIR/Dnsmanager
        fi
    }
    createFolder
    createtextlog
    CreatetextDns
    
    clear

}
# ---- End:Folder. ----
# ---- strat:function file. ----
function loadFile () {
    for FILE in `find /$DIRFile -iname "$FileDnsName" -type f`
    do
        #Some function on the file
        #echo "FILE = $FILE"
        for fileline in $(cat "$FILE"); do
            if [[ "$fileline" != "#"* ]]; then 
                IFS=';'
                splitline=($fileline)
                List_Server["${splitline[0]}"]="${splitline[1]};${splitline[2]}"
                IFS=""
            fi
        done
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
# ---- End:function file. ----

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
    createdata
    Main
fi

