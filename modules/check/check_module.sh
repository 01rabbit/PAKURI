#!/bin/bash
source pakuri.conf
outDir="$WDIR/result"

function check_manage() {
    dialog --backtitle "PAKURI > Check " \
        --title "Check Manage" \
        --menu "You can check the PAKURI log and various scan results files. " 10 70 2 \
        "1" "Log        PAKURI log." \
        "2" "File       Results of various scans." 2>temp
    result=$(cat temp)
    case "${result}" in
    1) #log
        more pakuri.log
        read -p "Press Enter to continue..."
        break
        ;;
    2) #file
        options=$(find $outDir -mindepth 1 -maxdepth 1 -type f -not -name '.*' -printf "%f %TY-%Tm-%Td-%TH-%TM \n" | sort)
        selected_files=$(dialog --backtitle "PAKURI > Check > File " --cancel-label Back --menu "Pick files out of $outDir" 35 75 20 $options --output-fd 1)
        if [ -z $selected_files ]; then
            dialog --title "Check files" --clear --msgbox "File not found." 6 45
        else
            for f in $selected_files; do
                less $outDir/$f
            done
        fi
        break
        ;;
    esac
    rm -f temp
    clear
}
