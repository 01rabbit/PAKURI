#!/bin/bash
source pakuri.conf
YMDHM=$(date +%F-%H-%M)
outDir="${WDIR}/result"
resultFile="${outDir}/vulnCheck-${YMDHM}.csv"
tmpFile="tmp-${YMDHM}.txt"

function usage_exit() {
    echo "Usage: $0 [-h] [-d DIR| -f FILE] "
    exit 1
}

function checkVuln() {
    totalLines=$(wc -l "${inFile}" | awk '{print $1}')
    thisCount=0
    while read thisLine; do
        let thisCount=thisCount+1
        checkForHost=$(echo "${thisLine}" | grep 'Nmap scan report for' | awk '{print $NF}' | tr -d '()')
        if [ "${checkForHost}" != "" ]; then thisHost="${checkForHost}"; fi
        checkForPort=$(echo "${thisLine}" | grep '/tcp')
        # checkForPort=$(echo "${thisLine}" | grep 'open')
        if [ "${checkForPort}" != "" ]; then thisPort="${checkForPort}"; fi
        checkForNSE=$(echo "${thisLine}" | grep '|[ _][A-Za-z0-9-]*:' | awk -F: '{print $1}' | tr -d '| _:')
        if [ "${checkForNSE}" != "" ]; then thisNSE="${checkForNSE}"; fi
        checkForState=$(echo "${thisLine}" | grep 'State: VULNERABLE\|State: LIKELY VULNERABLE' | awk -F: '{print $2}' | sed 's/^ //g')
        if [ "${checkForState}" != "" ]; then
            thisState="${checkForState}"
            echo "${thisHost},${thisPort},${thisNSE},${thisState}" >>temp
        fi
    done <"${inFile}"
}
if [ $# = 0 ]; then usage_exit; fi
printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "Checking for vulnerabilities." >>pakuri.log

while getopts :d:f:h OPT; do
    case ${OPT} in
    d) # Dir
        FLAG_D=1
        DIR=${OPTARG}
        for i in $(find ${DIR}/ -name "*.nmap" -type f); do cat $i >>${tmpFile}; done
        ;;
    f) # File
        FLAG_F=1
        FILE=${OPTARG}
        ;;
    h) # Help
        usage_exit
        ;;
    \?)
        echo "option error"
        usage_exit
        ;;
    esac
done

shift $((OPTIND - 1))
if [[ ${FLAG_D} ]]; then inFile=${tmpFile}; fi
if [[ ${FLAG_F} ]]; then inFile=${FILE}; fi
checkVuln

if [ -e temp ]; then
    sort temp | uniq >> "$resultFile"
    rm temp
fi

if [ -e ${tmpFile} ]; then rm ${tmpFile}; fi

size=$(wc -c ${resultFile} | awk '{print $1}')
if [ $size -eq 0 ]; then
    rm ${resultFile}
else
    while read line; do
        IFS=, msg=(${line})
        _thisHost=${msg[0]}
        _thisPort=$(echo ${msg[1]} | awk '{print $1}')
        _thisNSE=${msg[2]}
        _thisState=${msg[3]}
        printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${_thisHost} ${_thisPort} ${_thisNSE} ${_thisState}" >>pakuri.log
    done <${resultFile}
fi
printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "Vulnerability checks have been completed." >>pakuri.log
exit 0
