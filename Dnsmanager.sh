#! /bin/bash

nameApp="Dnsmanager"
FileDnsName="ListDns.txt"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIRFile="$DIR/$nameApp"
resolvFile='/etc/resolv.conf'
hostFile='/etc/hosts'
declare -A List_Server=()
select_Server=""
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
            echo "OpenDNS;208.67.220.220;208.67.222.222" >> /$DIRFile/ListDns.txt
            echo "Neustar;156.154.70.5;156.154.71.5" >> /$DIRFile/ListDns.txt
            echo "SafeDNS;195.46.39.39;195.46.39.40" >> /$DIRFile/ListDns.txt
            echo "Shecan;178.22.122.100;185.51.200.2" >> /$DIRFile/ListDns.txt
            echo "Electro;78.157.42.100;78.157.42.101" >> /$DIRFile/ListDns.txt
            echo "RadarGame;10.202.10.10;10.202.10.11" >> /$DIRFile/ListDns.txt
            echo "Online403;10.202.10.102;10.202.10.202" >> /$DIRFile/ListDns.txt
            echo "Begzar;185.55.226.26;185.55.226.25" >> /$DIRFile/ListDns.txt
            echo "quad9;9.9.9.9;149.112.112.112" >> /$DIRFile/ListDns.txt
            echo "alternate-dns;76.76.19.19;76.223.122.150" >> /$DIRFile/ListDns.txt
            echo "cleanbrowsing;185.228.168.168;185.228.169.168" >> /$DIRFile/ListDns.txt
            echo "opennic_1;195.10.195.195;152.53.15.127" >> /$DIRFile/ListDns.txt
            echo "opennic_2;37.252.191.197;94.247.43.254" >> /$DIRFile/ListDns.txt
            echo "yandex;77.88.8.8;77.88.8.1" >> /$DIRFile/ListDns.txt
            echo "Level3;209.244.0.3;209.244.0.4" >> /$DIRFile/ListDns.txt
            echo "dnswatch;84.200.69.80;84.200.70.40" >> /$DIRFile/ListDns.txt
            #append log
            echo "Create db Dns " >> /$DIRFile/log.txt
            sudo yum install GeoIP GeoIP-data -y
            echo "install GeoIP " >> /$DIRFile/log.txt

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
        temp=0
        #echo "FILE = $FILE"
        for fileline in $(cat "$FILE"); do
            if [[ "$fileline" != "#"* ]]; then 
                IFS=";" read -r -a splitline <<< "$fileline"
                List_Server[$temp]="${splitline[0]}=${splitline[1]};${splitline[2]}"
                ((temp++))
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
# ---- strat:function work dns. ----
function Reset_Dns_All_File () {
	echo "# This is /run/systemd/resolve/resolv.conf managed by man:systemd-resolved(8)." > $resolvFile
	echo "# Do not edit." >> $resolvFile
	echo "# " >> $resolvFile
	echo "# This file might be symlinked as /etc/resolv.conf. If you're looking at" >> $resolvFile
	echo "# /etc/resolv.conf and seeing this text, you have followed the symlink." >> $resolvFile
	echo "# " >> $resolvFile
	echo "# This is a dynamic resolv.conf file for connecting local clients directly to" >> $resolvFile
	echo "# all known uplink DNS servers. This file lists all configured search domains." >> $resolvFile
	echo "# " >> $resolvFile
	echo "# Third party programs should typically not access this file directly, but only" >> $resolvFile
	echo "# through the symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a" >> $resolvFile
	echo "# different way, replace this symlink by a static file or a different symlink." >> $resolvFile
	echo "# " >> $resolvFile
	echo "# See man:systemd-resolved.service(8) for details about the supported modes of" >> $resolvFile
	echo "# operation for /etc/resolv.conf." >> $resolvFile
	echo " " >> $resolvFile
	echo "nameserver 127.0.0.53" >> $resolvFile
	echo "options edns0 trust-ad" >> $resolvFile
	echo "search ." >> $resolvFile
}
function Chack_Dns () {
	echo "Chaking Dns ..."
	sudo systemctl daemon-reload
	sudo systemctl restart systemd-networkd
	sudo systemctl restart systemd-resolved
	#sudo systemctl start resolvconf.service
	#sudo systemctl enable resolveconf.service
	#sleep 10
 	systemd-resolve --status | grep "DNS Servers"
}
function SetDns() {
    key="$1"
	var_Find=0;
    IFS="=" read -r -a Dns <<< "${List_Server[$key]}"
    #Dns[0]=namedns /Dns[1]= server1;server2
    IFS=";" read -r -a Dns_Server <<< "${Dns[1]}"
	#echo -e "nameserver $Dns_1 \nnameserver $Dns_2" > $resolvFile
	while read -r CURRENT_LINE
		do
			if [[ $CURRENT_LINE == *'nameserver '* ]];then
				#sed -i 's/nameserver.*/nameserver '$Dns_1'\nnameserver '$Dns_2'/' $resolvFile
				if [[ $var_Find -eq 0 ]]; then
					sed -i.bak '/nameserver /d' $resolvFile
					echo -e "nameserver ${Dns_Server[0]}\nnameserver ${Dns_Server[1]}" >> $resolvFile
					((var_Find++))
					#sed -i 's/nameserver.*/nameserver '$Dns_1'\nnameserver '$Dns_2'/' $resolvFile
				fi
				
			fi
		#echo "$LINE: $CURRENT_LINE"
	done < "/etc/resolv.conf"
	if (( $var_Find == 1 )); then
		#zenity --info \
		#--text="Editing Dns $Dns_1 / $Dns_2"
		echo "Editing Dns => ${Dns[0]} = ${Dns[1]}"
		#nslookup $Dns_1
		Chack_Dns
	else
		echo "plz enter Defult Dns"
	fi
}
function  Select_Dns() {
    function  TestDns() {
        local Server=$1  # First argument
        #sleep 5
        ergebnis=$(ping -qc1 $Server) 
        ok=$?
        avg=$(echo -e "$ergebnis"  | tail -n1 | awk '{print $4}' | cut -f 2 -d "/")
        if [ $ok -eq 0 ]
        then
            return_function=$avg 
        else
            return_function=-1
        fi
        #echo "$avg => $return_function"
        echo $return_function
    }
	echo "Analysis Dns ..."
	#update Max Select Dns
    MinPing=9999
    select_best_server=0
	MaxSelectDns=${#List_Server[@]}
	# نمایش داده‌ها
    for key in "${!List_Server[@]}"; do
        IFS="=" read -r -a Dns <<< "${List_Server[$key]}"
        #Dns[0]=namedns /Dns[1]= server1;server2
        IFS=";" read -r -a Dns_Server <<< "${Dns[1]}"
        #echo "Name: ${Dns[0]}, server1: ${Dns_Server[0]}, server2: ${Dns_Server[1]}"
        location=$(geoiplookup  "${Dns_Server[0]}")
		Total=($(TestDns "${Dns_Server[0]}") + $(TestDns  "${Dns_Server[1]}"))
        if (( $(printf "%.0f" "$Total") < $(printf "%.0f" "$MinPing") && $(printf "%.0f" "$Total") > 0 )); then
            #echo "$Total < $MinPing && $Total > 0"
            MinPing=$Total
            select_best_server=$key
        fi
        echo -e "$key -(${location:23:2}) ${Dns[0]} = $Total"
    done
	echo "d. Defult Dns"
	echo "b. best dns (${List_Server[$select_best_server]})"
	echo "q. Quit "
	read -p "select in menu: " Selectmenu
	#clear
    if [ $Selectmenu >= 0 ] && [ $Selectmenu <= $MaxSelectDns]; then
        IFS=";" read -r -a Dns_Server <<< "${List_Server[$Selectmenu]}"
        echo -e "${List_Server[$Selectmenu]}"
        SetDns $Selectmenu
	else
		echo "${Selectmenu} is not a number"
        if [ "$Selectmenu" = "d" ] || [ "$Selectmenu" = "D" ]; then
            Reset_Dns_All_File
		elif [ "$Selectmenu" = "q" ] || [ "$Selectmenu" = "Q" ]; then
			echo "back menu"
		elif [ "$Selectmenu" = "b" ] || [ "$Selectmenu" = "B" ]; then
			SetDns $select_best_server
		fi
	fi
}
# ---- End:function work dns. ----
# ---- strat:function work host. ----
function Reset_host_File () {
	echo "# Loopback entries; do not change." > $hostFile
	echo "# For historical reasons, localhost precedes localhost.localdomain:" >> $hostFile
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> $hostFile
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> $hostFile
	echo "# See hosts(5) for proper format and other examples:" >> $hostFile
	echo "# 192.168.1.10 foo.example.org foo" >> $hostFile
	echo "# 192.168.1.13 bar.example.org bar" >> $hostFile
	echo " " >> $hostFile
}
function Set_host(){
    local result_host=$1
    names=$(echo "$result_host" | jq -r '.name')
    ip_count=$(echo "$result_host" | jq '.ip | length')
    ips=($(echo "$result_host" | jq -r '.ip[]'))
    count=1
    for ip in "${ips[@]}"; do
        echo "$ip $names" >> $hostFile
        return 0
        ((count++))
    done

}
function sub_bac_host(){
    if [ -f "/$DIRFile/hostbac" ]; then
        read -p "File found! repare file(y/n)?" Selectmenu 
        if test -z "$Selectmenu"; then
            echo "\$ input is null. input => ($Selectmenu)"
        else
            if [[ $Selectmenu =~ ^[0-9]+$ ]]; then
                echo "Number over list"
            else
                if [ "$Selectmenu" = "y" ] || [ "$Selectmenu" = "Y" ]; then
                    cp $hostFile /$DIRFile/hostbac
                elif [ "$Selectmenu" = "n" ] || [ "$Selectmenu" = "N" ]; then
                    echo "skip file bac"
                fi
                Set_host "$1"
            fi
        fi
    else   
        cp $hostFile /$DIRFile/hostbac
    fi 
}
function TestAllDns(){
    function Chack_dns_host(){
        local chackurls=$1
        local chackServer=$2
        #echo "nslookup $chackurls $chackServer"
        resolvedIP=$(nslookup $chackurls $chackServer |
            sed -n 's/^Address: //p' |
            jq -Rs --arg name "$chackurls" '{ name: $name ,ip: ( rtrimstr("\n") | split("\n") )}')
        #echo "resolvedIP= $resolvedIP"
        #echo "Name: $(echo "$resolvedIP" | jq -r '.name')"
        #echo "ip: $(echo "$resolvedIP" | jq -r '.ip[]')"
        echo $resolvedIP
    }
    chackurls="mirrors.fedoraproject.org"
    # نمایش داده‌ها
    for key in "${!List_Server[@]}"; do
        IFS="=" read -r -a Dns <<< "${List_Server[$key]}"
        #Dns[0]=namedns /Dns[1]= server1;server2
        IFS=";" read -r -a Dns_Server <<< "${Dns[1]}"
        #echo "Name: ${Dns[0]}, server1: ${Dns_Server[0]}, server2: ${Dns_Server[1]}"
        result_host=$(Chack_dns_host ${chackurls} ${Dns_Server[0]})
        ip_count=$(echo "$result_host" | jq '.ip | length')
        ips=($(echo "$result_host" | jq -r '.ip[]'))
        if ((ip_count > 0));then
            count=1
            echo "$key - ${Dns[0]}"
            for ip in "${ips[@]}"; do
                echo "  ip[$count/$ip_count]: $ip"
                ((count++))
            done
            #echo "nslookup $chackurls ${Dns_Server[1]} = $return_function"
            read -p "set in host(y/n/q)?" Selectmenu 

            if test -z "$Selectmenu"; then
                echo "\$ input is null. input => ($Selectmenu)"
            else
                if [ "$Selectmenu" = "y" ] || [ "$Selectmenu" = "Y" ]; then
                    sub_bac_host "$result_host"
                    return 0
                elif [ "$Selectmenu" = "n" ] || [ "$Selectmenu" = "N" ]; then
                    echo ""
                elif [ "$Selectmenu" = "q" ] || [ "$Selectmenu" = "Q" ]; then
                    return 0
                else
                    echo "input not valid"
                fi
            fi
        fi
    done
}

# ---- End:function work host. ----

function Main () {
    Filecheck
    Sectionname="Main App"
	while true 
		do
			echo "--------------- Menu App ---------------"
            echo "Menu for $Sectionname
    1. Select Dns
    2. Chack Dns
    3. add Dns to host
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
                        Select_Dns
                    elif [ $Selectmenu == 2 ]; then
                        Chack_Dns
                    elif [ $Selectmenu == 3 ]; then
                        TestAllDns
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

