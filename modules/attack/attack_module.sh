#!/bin/bash
source pakuri.conf

function use_searchsploit() {
    dialog --backtitle "PAKURI > Exploit > Searchsploit" \
        --inputbox "search word:" 8 40 2>temp
    result=$(cat temp)
    clear
    searchsploit $result
    read -p "Press Enter to continue..."
}
function use_brutespray() {
    if [[ ! -d $WDIR/brutespray ]]; then
        mkdir $WDIR/brutespray
    else
        rm $WDIR/brutespray/*.txt
    fi

    FILE=$(dialog --backtitle "PAKURI > Attack > Brutespray " \
        --stdout --title "Select a target file" --fselect ${WDIR}/result/xml/ 20 80)
    if [ ! -z $FILE ]; then
        clear
        brutespray --file $FILE --output $WDIR/brutespray/ --threads 5 --hosts 5
        read -p "Press Enter to continue..."
    fi
}
function attack_manage() {
    dialog --backtitle "PAKURI > Attack" \
        --colors --title "Attack Control" \
        --menu "Please select Tools: " 13 60 3 \
        "1" "Searchsploit       search exploit-db" \
        "2" "Brutespray         brute-force attack" \
        "3" "Metasploit         start metasploit" 2>temp
    result=$(cat temp)
    case ${result} in
    1) use_searchsploit ;;
    2) use_brutespray ;;
    3) ;;
    esac
    rm -f temp
    clear
}
attack_manage
exit 0
