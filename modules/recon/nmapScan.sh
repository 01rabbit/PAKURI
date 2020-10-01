#!/bin/bash

YMDHM=$(date +%F-%H-%M)
FLAG_E=""
FLAG_P=""
FLAG_T=""
FLAG_U=""
FLAG_O=""
outDir="$(pwd)"
function usage_exit() {
     cat <<EOM
     Usage: 
          $(basename "$0") [-heu] [-p port] [-l IPlist] [-o Output]
     
     Options:
          -h   Display help
          -e   Extra Scan
          -u   UDP Scan & Extra Scan
          -p   Port #
          -l   IP Address List
          -o   Output Directory

     Exsample:
          Single Host
               $(basename "$0") IP
          Multi Host
               $(basename "$0") -l <file name> 
          Extra Scan
               $(basename "$0") -e IP 
          Multi Host Extra Scan
               $(basename "$0") -e -l <file name> -o Output_Directry 
EOM
     exit 1
}

if [ $# = 0 ]; then usage_exit; fi

while getopts "eu:p:l:o:h" OPT; do
     case $OPT in
     e) # extraScan
          FLAG_E=1
          ;;
     u) # UDP
          FLAG_U=1
          ;;
     p) # Port
          FLAG_P=1
          PORT=$OPTARG
          ;;
     l) # List
          FLAG_L=1
          IPLIST=$OPTARG
          ;;
     o) # Output
          FLAG_O=1
          outDir=$OPTARG
          ;;
     h | *) # Help
          usage_exit
          ;;
     esac
done

shift $((OPTIND - 1))
if [[ ${FLAG_O} ]]; then
     if [[ ! -d ${outDir} ]]; then mkdir ${outDir}; fi
     if [[ ! -d ${outDir}/xml ]]; then mkdir ${outDir}/xml; fi
fi
#
# If an ip address is specified, make sure it is the coreect ip address.
# If no ip address is specified, use the target list.
#
if [[ ${FLAG_U} ]]; then
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "NmapScan UDP Start."
else
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "NmapScan Start."
fi

if [ $# = 1 ]; then
     IP=$1
     IP_CHECK=$(echo ${IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")
     if [[ ! ${IP_CHECK} ]]; then
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "ERROR" "${IP} is not IP Address."
          exit 1
     else
          if [[ ${FLAG_U} ]]; then
               thisFileName="${IP}_PortScan_UDP-${YMDHM}"
          else
               thisFileName="${IP}_PortScan-${YMDHM}"
          fi
     fi
else
     if [[ ${FLAG_L} ]]; then
          IP="-iL ${IPLIST}"
          if [[ ${FLAG_U} ]]; then
               thisFileName="ipList_PortScan_UDP-${YMDHM}"
          else
               thisFileName="ipList_PortScan-${YMDHM}"
          fi
     else
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "ERROR" "Not Target."
          exit 1
     fi
fi

#
# If a port is specified, the specifief port is used; if not, all ports are specified.
#
if [[ ${FLAG_P} ]]; then PORT="-p${PORT}"; else PORT="-p-"; fi

printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "Search for open ports."
if [[ ${FLAG_U} ]]; then
     sudo nmap -T4 -sU --max-retries 1 --max-scan-delay 20 --min-rate=500 ${PORT} ${IP} -oG ${outDir}/${thisFileName}.grep >/dev/null
else
     nmap -T4 --max-retries 1 --max-scan-delay 20 --min-rate=500 ${PORT} ${IP} -oG ${outDir}/${thisFileName}.grep >/dev/null
fi
if grep -Eo '[0-9]{1,4}/open' ${outDir}/${thisFileName}.grep >/dev/null; then
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "OK" "Valid ports found."
else
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "ERROR" "No valid port found."
     exit 1
fi

printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "NmapScan Filename : ${thisFileName}"
printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "Start scanning Nmap."

if [[ ${FLAG_U} ]]; then
     sudo nmap -sCVU -p $(grep -Eo '[0-9]{1,4}/open' ${outDir}/${thisFileName}.grep | cut -d '/' -f 1 | tr -s '\n' ',') ${IP} -oX ${outDir}/xml/$thisFileName.xml >${outDir}/$thisFileName.nmap 2>/dev/null
else
     nmap -sCV -p $(grep -Eo '[0-9]{1,4}/open' ${outDir}/${thisFileName}.grep | cut -d '/' -f 1 | tr -s '\n' ',') ${IP} -oX ${outDir}/xml/$thisFileName.xml >${outDir}/$thisFileName.nmap 2>/dev/null
fi
printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "Scan complete."

if [[ ${FLAG_E} ]]; then
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "Start scanning with Nmap Script Engine."
     egrep -v "^#|Status: Up" ${outDir}/${thisFileName}.grep | cut -d' ' -f2,4- | awk '{ip=$1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/");printf "%s,%s/%s,%s\n" ,ip, v[1], v[3], v[5]}; a="" }' | grep -i "$1" >list.txt
     cat list.txt | xargs -n 1 -L 1 -P 10 -l extraScan.sh
     rm list.txt
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "NSE Scan complete."
     $MODULES_PATH/recon/vuln.sh -d ${outDir}
fi

rm ${outDir}/${thisFileName}.grep
exit 0
