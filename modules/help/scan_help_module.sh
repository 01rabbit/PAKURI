#!/bin/bash
source pakuri.conf

function help_portscan()
{
    clear
    echo -e ""
    echo -e "${BLUE_b}+---+  +---+  +---+"
    echo -e "${BLUE_b}| 1 |  | 1 |  | 1 |  Port Scan"
    echo -e "${BLUE_b}+---+  +---+  +---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "Overview"
    echo -e "   Use Nmap to perform a port scan."
    echo -e ""
    echo -e "${GREEN_b}Step 1${NC}"
    echo -e "   First, use the following command to store the freed port number in a variable(PORT)."
    echo -e ""
    echo -e "Use Command:"
    echo -e "Details"
    echo -e "   nmap -Pn -p- -v --min-rate=1000 -T4 <IP Address>"
    echo -e "Options:"
    echo -e "   -Pn: Treat all hosts as online -- skip host discovery"
    echo -e "   -p <port ranges>: Only scan specified ports"
    echo -e "   -v: Increase verbosity level (use -vv or more for greater effect)"
    echo -e "   --min-rate <number>: Send packets no slower than <number> per second"
    echo -e "   -T<0-5>: Set timing template (higher is faster)"
    echo -e ""
    echo -e "${GREEN_b}Step 2${NC}"
    echo -e "   Next, we run a scan on the freed port using the previous variable(PORT)."
    echo -e ""
    echo -e "Use Command:"
    echo -e "Details"
    echo -e "   nmap -sV -v --script= *vuln* -p\$PORT <IP Address> -oN <.nmap file> -oG <.grep file>"
    echo -e "Options:"
    echo -e "   -sV: Probe open ports to determine service/version info"
    echo -e "   --script=<Lua scripts>: <Lua scripts> is a comma separated list of"
    echo -e "       directories, script-files or script-categories"
    echo -e "   -oN/-oX/-oS/-oG <file>: Output scan in normal, XML, s|<rIpt kIddi3,"
    echo -e "       and Grepable format, respectively, to the given filename."
}

function help_vulnerscan()
{
    clear
    echo -e ""
    echo -e "${BLUE_b}+---+  +---+  ${RED_b}+---+"
    echo -e "${BLUE_b}| 1 |  | 1 |  ${RED_b}| 2 |  Vulners Scan"
    echo -e "${BLUE_b}+---+  +---+  ${RED_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "Overview"
    echo -e "   Use NSE scripts(nmap_vulners) to enumerate known vulnerability information."
    echo -e ""
    echo -e "${GREEN_b}Step 1${NC}"
    echo -e "   First, use the following command to store the freed port number in a variable(PORT)."
    echo -e ""
    echo -e "Use Command:"
    echo -e "Details"
    echo -e "   nmap -Pn -p- -v --min-rate=1000 -T4 <IP Address>"
    echo -e "Options:"
    echo -e "   -Pn: Treat all hosts as online -- skip host discovery"
    echo -e "   -p <port ranges>: Only scan specified ports"
    echo -e "   -v: Increase verbosity level (use -vv or more for greater effect)"
    echo -e "   --min-rate <number>: Send packets no slower than <number> per second"
    echo -e "   -T<0-5>: Set timing template (higher is faster)"
    echo -e ""
    echo -e "${GREEN_b}Step 2${NC}"
    echo -e "   Next, we enumerate the known vulnerabilities of the freed ports using the previous variable(PORT)."
    echo -e ""
    echo -e "Use Command:"
    echo -e "Details"
    echo -e "   nmap -Pn -v -sV --max-retries 1 --max-scan-delay 20 --script vulners --script-args mincvss=6.0 -p\$PORT <IP Address> -oN <.nmap file>"
    echo -e "Options:"
    echo -e "   -sV: Probe open ports to determine service/version info"
    echo -e "   --script=<Lua scripts>: <Lua scripts> is a comma separated list of"
    echo -e "       directories, script-files or script-categories"
    echo -e "   --script-args=<n1=v1,[n2=v2,...]>: provide arguments to scripts"
    echo -e "   -oN/-oX/-oS/-oG <file>: Output scan in normal, XML, s|<rIpt kIddi3,"
    echo -e "       and Grepable format, respectively, to the given filename."
}

function help_enumeration()
{
    clear
    echo -e ""
    echo -e "${BLUE_b}+---+  ${RED_b}+---+"
    echo -e "${BLUE_b}| 1 |  ${RED_b}| 2 |  Enumeration"
    echo -e "${BLUE_b}+---+  ${RED_b}+---+${NC}"
    echo -e "------------------------------------------------------"
    echo -e "Overview"
    echo -e "   Use the various commands to enumerate against the open ports."
    echo -e ""
    echo -e "${GREEN_b}SSH${NC}"
    echo -e "Use Command:"
    echo -e "   nmap -sV -p <Target Port> --script='banner,ssh2-enum-algos,ssh-hostkey,ssh-auth-methods' <IP Address>"
    echo -e "Result:"
    echo -e "   $WDIR/ssh_<IP Address>:<SSH Port>.nmap"
    echo -e ""
    echo -e "${GREEN_b}HTTP${NC}"
    echo -e "Use Commands:"
    echo -e "   nikto -h http://<IP Address>:<HTTP Port> "
    echo -e "   skipfish -U -u -Q -t 12 -W- -o $WDIR/skipfish_<IP Address>_<HTTP Port> http://<IP Address>:<HTTP Port>"
    echo -e "Results:"
    echo -e "   $WDIR/nikto_<IP Address>:<HTTP Port>.txt"
    echo -e "   $WDIR/skipfish_<IP Address>_<HTTP Port>/index.html"
    echo -e ""
    echo -e "${GREEN_b}HTTPS${NC}"
    echo -e "Use Commands:"
    echo -e "   nikto -h https://<IP Address>:<HTTPS Port> "
    echo -e "   skipfish -U -u -Q -t 12 -W- -o $WDIR/skipfish_<IP Address>_<HTTPS Port> https://<IP Address>:<HTTPS Port>"
    echo -e "   sslyze --regular <IP Address>"
    echo -e "   sslscan <IP Address>"
    echo -e "Results:"
    echo -e "   $WDIR/nikto_<IP Address>:<HTTP Port>.txt"
    echo -e "   $WDIR/skipfish_<IP Address>_<HTTP Port>/index.html"
    echo -e "   $WDIR/sslyze_<IP Address>.txt"
    echo -e "   $WDIR/sslscan_<IP Address>.txt"
    echo -e ""
    echo -e "${GREEN_b}netbios-ssn${NC}|${GREEN_b}microsoft-ds${NC}"
    echo -e "Use Commnads:"
    echo -e "   nmap -sV -p <Target Port> --script='*smb-vuln* and not brute or broadcast or dos or external or fuzzer' <IP Address>" 
    echo -e "   enum4linux -a -M -1 -d <IP Address>"
    echo -e "Results:"
    echo -e "   $WDIR/smb_<IP Address>:<Target Port>.nmap"
    echo -e "   $WDIR/enum4linux_<IP Address>:<Target Port>.txt"
}

case $1 in
    111)
        help_portscan;;
    112)
        help_vulnerscan;;
    12)
        help_enumeration;;
esac