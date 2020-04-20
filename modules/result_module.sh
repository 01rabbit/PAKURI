#!/bin/bash
source pakuri.conf
source $MODULES/misc_module.sh

clear

array=($(find $WDIR \( -name \*.nmap -or -name \*.xml \)))
choice=0
tail=`expr ${#array[@]} - 1`
echo -e "${GREEN_b}Choose one${NC}" >&2

for _ in $(seq 0 $tail);do echo "";done
while true
do
    printf "\e[${#array[@]}A\e[m" >&2

    for i in $(seq 0 $tail);do
        if [ $choice = $i ];then
            printf "${RED_b}>${NC} ${YELLOW_b}" >&2
        else
            printf "  " >&2
        fi
        echo -e "${array[$i]}${NC}" >&2
    done

    IFS= read -r -n1 -s char
    if [[ $char == $'\x1b' ]];then
        read -r -n2 -s rest
        char+="$rest"
    fi
    case $char in
            $'\x1b\x5b\x41')
                if [ $choice -gt 0 ];then
                    choice=`expr $choice - 1`
                fi
                ;;
            $'\x1b\x5b\x42')
                if [ $choice -lt $tail ];then
                    choice=`expr $choice + 1`
                fi
                ;;
            "")
                less "${array[$choice]}"
                break
                ;;
    esac
done