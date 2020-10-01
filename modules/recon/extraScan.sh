#!/bin/bash
source pakuri.conf

YMDHM=$(date +%F-%H-%M)
outDir="${WDIR}/result"

thisHost=$(echo $1 | awk -F "," '{print $1}')
thisPort=$(echo $1 | awk -F "," '{print $2}')
thisServName=$(echo $1 | awk -F "," '{print $3}')

if [[ ${thisPort} = "13/tcp" ]]; then
     thisServName="Daytime"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p13 --script-timeout 20s --script=daytime --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "21/tcp" ]]; then
     thisServName="FTP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p21 --script-timeout 20s --script=banner,ftp-anon,ftp-bounce,ftp-proftpd-backdoor,ftp-syst,ftp-vsftpd-backdoor,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "22/tcp" ]]; then
     thisServName="SSH"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p22 --script-timeout 20s --script=rsa-vuln-roca,sshv1,ssh2-enum-algos --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "23/tcp" ]]; then
     thisServName="Telnet"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p23 --script-timeout 20s --script=banner,cics-info,cics-enum,cics-user-enum,telnet-encryption,telnet-ntlm-info,tn3270-screen,tso-enum --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "25/tcp" ]] || [[ ${thisPort} = "465/tcp" ]] || [[ ${thisPort} = "587/tcp" ]]; then
     thisServName="SMTP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          nmap ${thisHost} -Pn -n --open -p25,465,587 --script-timeout 20s --script=banner,smtp-commands,smtp-ntlm-info,smtp-open-relay,smtp-strangeport,smtp-enum-users,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --script-args smtp-enum-users.methods={EXPN,RCPT,VRFY} --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi

if [[ ${thisPort} = "37/tcp" ]]; then
     thisServName="Time"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p37 --script-timeout 20s --script=rfc868-time --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "53/tcp" ]] || [[ ${thisPort} = "53/udp" ]]; then
     thisServName="DNS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sS -sU --open -p53 --script-timeout 20s --script=dns-blacklist,dns-cache-snoop,dns-nsec-enum,dns-nsid,dns-random-srcport,dns-random-txid,dns-recursion,dns-service-discovery,dns-update,dns-zeustracker,dns-zone-transfer --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} dnsrecon"
     subnet=$(echo "${thisHost}" | cut -d "." -f 1,2,3)".0"
     dnsrecon -r ${subnet}/24 -n ${thisHost} >${outDir}/${thisFileName}_dnsrecon.txt
     dnsrecon -r 127.0.0.0/24 -n ${thisHost} >${outDir}/${thisFileName}_dnsrecon-local.txt
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} dig"
     dig -x ${thisHost} @${thisHost} >${outDir}/${thisFileName}_dig.txt

fi

if [[ ${thisPort} = "67/tcp" ]]; then
     thisServName="DHCP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n -sU --open -p67 --script-timeout 20s --script=dhcp-discover --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "70/tcp" ]]; then
     thisServName="Gopher"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p70 --script-timeout 20s --script=gopher-ls --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "79/tcp" ]]; then
     thisServName="Finger"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p79 --script-timeout 20s --script=finger --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ $thisServName = "http" ]] || [[ $thisServName = "ssl/http" ]] || [[ $thisServName = "https" ]]; then
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisPort=$(echo ${thisPort} | awk -F "/" '{print $1}')
     if [[ $thisServName = "http" ]]; then
          thisFileName="${thisHost}_http_${thisPort}"
     else
          thisFileName="${thisHost}_https_${thisPort}"
     fi
     nmap ${thisHost} -Pn -sV -n --open -p ${thisPort} --script-timeout 20s --script=http-adobe-coldfusion-apsa1301,http-affiliate-id,http-apache-negotiation,http-apache-server-status,http-aspnet-debug,http-auth-finder,http-auth,http-avaya-ipoffice-users,http-awstatstotals-exec,http-axis2-dir-traversal,http-backup-finder,http-barracuda-dir-traversal,http-brute,http-cakephp-version,http-chrono,http-cisco-anyconnect,http-coldfusion-subzero,http-comments-displayer,http-config-backup,http-cookie-flags,http-cors,http-cross-domain-policy,http-csrf,http-date,http-default-accounts,http-devframework,http-dlink-backdoor,http-dombased-xss,http-domino-enum-passwords,http-drupal-enum,http-drupal-enum-users,http-enum,http-errors,http-exif-spider,http-favicon,http-feed,http-fetch,http-fileupload-exploiter,http-form-brute,http-form-fuzzer,http-frontpage-login,http-generator,http-git,http-gitweb-projects-enum,http-google-malware,http-grep,http-headers,http-huawei-hg5xx-vuln,http-icloud-findmyiphone,http-icloud-sendmsg,http-iis-short-name-brute,http-iis-webdav-vuln,http-internal-ip-disclosure,http-joomla-brute,http-litespeed-sourcecode-download,http-ls,http-majordomo2-dir-traversal,http-malware-host,http-mcmp,http-methods,http-method-tamper,http-mobileversion-checker,http-ntlm-info,http-open-proxy,http-open-redirect,http-passwd,http-phpmyadmin-dir-traversal,http-phpself-xss,http-php-version,http-proxy-brute,http-put,http-qnap-nas-info,http-referer-checker,http-rfi-spider,http-robots.txt,http-robtex-reverse-ip,http-robtex-shared-ns,http-security-headers,http-server-header,http-shellshock,http-sitemap-generator,http-slowloris-check,http-slowloris,http-sql-injection,http-stored-xss,http-svn-enum,http-svn-info,http-title,http-tplink-dir-traversal,http-trace,http-traceroute,http-unsafe-output-escaping,http-useragent-tester,http-userdir-enum,http-vhosts,http-virustotal,http-vlcstreamer-ls,http-vmware-path-vuln,http-vuln-cve2006-3392,http-vuln-cve2009-3960,http-vuln-cve2010-0738,http-vuln-cve2010-2861,http-vuln-cve2011-3192,http-vuln-cve2011-3368,http-vuln-cve2012-1823,http-vuln-cve2013-0156,http-vuln-cve2013-6786,http-vuln-cve2013-7091,http-vuln-cve2014-2126,http-vuln-cve2014-2127,http-vuln-cve2014-2128,http-vuln-cve2014-2129,http-vuln-cve2014-3704,http-vuln-cve2014-8877,http-vuln-cve2015-1427,http-vuln-cve2015-1635,http-vuln-cve2017-1001000,http-vuln-cve2017-5638,http-vuln-cve2017-5689,http-vuln-cve2017-8917,http-vuln-misfortune-cookie,http-vuln-wnr1000-creds,http-waf-detect,http-waf-fingerprint,http-webdav-scan,http-wordpress-brute,http-wordpress-enum,http-wordpress-users,http-xssed,membase-http-info,riak-http-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap

     result=$(cat ${outDir}/${thisFileName}.nmap)
     for line in ${result}; do
          if [[ ! -z $(echo "${line}" | grep -w "IIS") ]]; then
               pages=".html,.php,.asp,.aspx"
          else
               pages=".html,.php"
          fi
     done
     windowname="$(echo ${thisHost} | sed -e 's/\.//g')_${thisPort}"
     if [[ $thisServName = "http" ]]; then
          tmux new-window -n "${windowname}_gobuster"
          tmux send-keys -t "${windowname}_gobuster" "gobuster dir -w /usr/share/wordlists/dirb/common.txt -l -t 30 -e -k -x $pages -u http://${thisHost}:${thisPort} -o ${outDir}/${thisFileName}_gobuster.txt ; exit" C-m
          tmux new-window -n "${windowname}_nikto"
          tmux send-keys -t "${windowname}_nikto" "nikto -host ${thisHost}:${thisPort} | tee ${outDir}/${thisFileName}_nikto.txt ;exit" C-m
     else
          tmux new-window -n "${windowname}_gobuster"
          tmux send-keys -t "${windowname}_gobuster" "gobuster dir -w /usr/share/wordlists/dirb/common.txt -l -t 30 -e -k -x $pages -u https://${thisHost}:${thisPort} -o ${outDir}/${thisFileName}_gobuster.txt ; exit" C-m
          tmux new-window -n "${windowname}_nikto"
          tmux send-keys -t "${windowname}_nikto" "nikto -host https://${thisHost}:${thisPort} -ssl | tee ${outDir}/${thisFileName}_nikto.txt ;exit" C-m
     fi
     tmux select-window -t "Main"
     if [[ ${thisPort} = "443" ]]; then
          thisServName="SSL"
          thisFileName="${thisHost}_${thisServName}"
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} sslscan"
          sslscan --ipv4 --show-certificate --ssl2 --ssl3 --tlsall --no-colour ${thisHost} >${outDir}/${thisFileName}-sslscan.txt
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} sslyze"
          sslyze ${thisHost} --resum --reneg --heartbleed --certinfo --sslv2 --sslv3 --hide_rejected_ciphers --openssl_ccs >${outDir}/${thisFileName}-sslyze.txt
          nmap ${thisHost} -Pn -n -T4 --open -p443 --script-timeout 20s -sV --script=rsa-vuln-roca,ssl*,tls-alpn,tls-ticketbleed --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
          thisServName="VMware"
          thisFileName="${thisHost}_${thisServName}"
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
          nmap ${thisHost} -Pn -n --open -p443 --script-timeout 20s --script=vmware-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi

if [[ ${thisPort} = "102/tcp" ]]; then
     thisServName="S7"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p102 --script-timeout 20s --script=s7-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "110/tcp" ]]; then
     thisServName="POP3"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p110 --script-timeout 20s --script=banner,pop3-capabilities,pop3-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "111/tcp" ]]; then
     thisServName="RPC"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p111 --script-timeout 20s --script=nfs-ls,nfs-showmount,nfs-statfs,rpcinfo --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "119/tcp" ]] || [[ ${thisPort} = "433/tcp" ]] || [[ ${thisPort} = "563/tcp" ]]; then
     thisServName="NNTP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          nmap ${thisHost} -Pn -n --open -p119,433,563 --script-timeout 20s --script=nntp-ntlm-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi

if [[ ${thisPort} = "123/udp" ]]; then
     thisServName="NTP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p123 --script-timeout 20s --script=ntp-info,ntp-monlist --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "137/udp" ]]; then
     thisServName="NetBIOS-ns"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p137 --script-timeout 20s --script=nbstat --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "139/tcp" ]]; then
     thisServName="NetBIOS-ssn"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p139 --script-timeout 20s --script=smb-vuln-cve-2017-7494,smb-vuln-ms10-061,smb-vuln-ms17-010 --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "143/tcp" ]]; then
     thisServName="IMAP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p143 --script-timeout 20s --script=imap-capabilities,imap-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "161/udp" ]]; then
     thisServName="SNMP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p161 --script-timeout 20s --script=snmp-hh3c-logins,snmp-info,snmp-interfaces,snmp-netstat,snmp-processes,snmp-sysdescr,snmp-win32-services,snmp-win32-shares,snmp-win32-software,snmp-win32-users -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} onesixtyone"
     onesixtyone -c /usr/share/doc/onesixtyone/dict.txt -i ${thisHost} >>${outDir}/${thisFileName}_onesixtyone.txt
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} snmp-check"
     snmp-check ${thisHost} -c public >>${outDir}/${thisFileName}_snmp-check.txt 2>/dev/null
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} snmpwalk"
     snmpwalk -Os -c public -v1 ${thisHost} >>${outDir}/${thisFileName}_snmpwalk.txt 2>/dev/null
fi

if [[ ${thisPort} = "389/tcp" ]]; then
     thisServName="LDAP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p389 --script-timeout 20s --script=ldap-rootdse,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} ldapsearch"
     ldapsearch -x -h ${thisHost} -s base >${outDir}/${thisFileName}_ldapsearch.txt
     ldapsearch -x -h ${thisHost} -b $(cat ${outDir}/${thisFileName}_ldapsearch.txt | grep rootDomainNamingContext | cut -d ' ' -f2) >${outDir}/${thisFileName}_DC_ldapsearch.txt
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName} ldap nse"
     nmap ${thisHost} -Pn -p389 --script ldap-search --script-args 'ldap.username="$(cat ${outDir}/${thisFileName}_ldapsearch.txt | grep rootDomainNamingContext | cut -d \" \" -f2)"' -oX ${outDir}/xml/${thisFileName}_ladp.xml >${outDir}/${thisFileName}_ldap.nmap
fi

if [[ ${thisPort} = "445/tcp" ]]; then
     thisServName="SMB"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p445 --script-timeout 20s --script=smb-double-pulsar-backdoor,smb-enum-domains,smb-enum-groups,smb-enum-processes,smb-enum-services,smb-enum-sessions,smb-enum-shares,smb-enum-users,smb-mbenum,smb-os-discovery,smb-protocols,smb-security-mode,smb-server-stats,smb-system-info,smb2-capabilities,smb2-security-mode,smb2-time,msrpc-enum,stuxnet-detect --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  smbmap"
     smbmap -H ${thisHost} >>${outDir}/${thisFileName}_smbmap.txt 2>/dev/null
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  smbclient"
     smbclient -L \"//${thisHost}/\" -U \"guest\"% >>${outDir}/${thisFileName}_smbclient.txt 2>/dev/null

     pingTest=$(ping -c 1 -W 3 "${thisHost}" | grep ttl)
     if [[ ! -z $pingTest ]]; then ttl=$(echo "${pingTest}" | cut -d " " -f 6 | cut -d "=" -f 2); fi
     if [ "$ttl" == 128 ] || [ "$ttl" == 127 ]; then
          checkOS="Windows"
     elif [ "$ttl" == 64 ] || [ "$ttl" == 63 ]; then
          checkOS="Linux"
     fi
     if [[ $checkOS == "Windows" ]]; then
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  smb vuln"
          nmap ${thisHost} -Pn -n --open -p445 --script-timeout 20s --script vuln --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}_vuln.xml >${outDir}/${thisFileName}_vuln.nmap
     fi
     if [[ $checkOS == "Linux" ]]; then
          printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  enum4linux"
          enum4linux -a ${thisHost} >${outDir}/${thisFileName}_enum4linux.txt 2>/dev/null
     fi
fi

if [[ ${thisPort} = "500/tcp" ]] || [[ ${thisPort} = "500/udp" ]]; then
     thisServName="ISAKMP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          sudo nmap ${thisHost} -Pn -n -sS -sU --open -p500 --script-timeout 20s --script=ike-version -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
          ike-scan -f ${thisHost} >${thisFileName}-ike-scan.txt
     fi
fi

if [[ ${thisPort} = "523/tcp" ]] || [[ ${thisPort} = "523/udp" ]]; then
     thisServName="DB2"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          sudo nmap ${thisHost} -Pn -n -sS -sU --open -p523 --script-timeout 20s --script=db2-das-info,db2-discover --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi

if [[ ${thisPort} = "524/tcp" ]]; then
     thisServName="NCP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p524 --script-timeout 20s --script=ncp-enum-users,ncp-serverinfo --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "548/tcp" ]]; then
     thisServName="AFP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p548 --script-timeout 20s --script=afp-ls,afp-path-vuln,afp-serverinfo,afp-showmount --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "554/tcp" ]]; then
     thisServName="RTSP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p554 --script-timeout 20s --script=rtsp-methods --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "623/udp" ]]; then
     thisServName="IPMI"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p623 --script-timeout 20s --script=ipmi-version,ipmi-cipher-zero --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "631/tcp" ]]; then
     thisServName="CUPS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p631 --script-timeout 20s --script=cups-info,cups-queue-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "636/tcp" ]]; then
     thisServName="LDAP-S"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p636 --script-timeout 20s --script=ldap-rootdse,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "873/tcp" ]]; then
     thisServName="rsync"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p873 --script-timeout 20s --script=rsync-list-modules --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "993/tcp" ]]; then
     thisServName="IMAPS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p993 --script-timeout 20s --script=banner,imap-capabilities,imap-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "995/tcp" ]]; then
     thisServName="POP3S"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p995 --script-timeout 20s --script=banner,pop3-capabilities,pop3-ntlm-info,ssl-cert,ssl-cert-intaddr,ssl-ccs-injection,ssl-date,ssl-dh-params,ssl-enum-ciphers,ssl-heartbleed,ssl-known-key,ssl-poodle,sslv2,sslv2-drown,tls-nextprotoneg -sV --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1050/tcp" ]]; then
     thisServName="COBRA"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1050 --script-timeout 20s --script=giop-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1080/tcp" ]]; then
     thisServName="SOCKS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1080 --script-timeout 20s --script=socks-auth-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1099/tcp" ]]; then
     thisServName="RMI-Registry"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1099 --script-timeout 20s --script=rmi-dumpregistry,rmi-vuln-classloader --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1344/tcp" ]]; then
     thisServName="ICAP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1344 --script-timeout 20s --script=icap-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1352/tcp" ]]; then
     thisServName="LotusDomino"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1352 --script-timeout 20s --script=domino-enum-users --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1433/tcp" ]]; then
     thisServName="MS-SQL"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1433 --script-timeout 20s --script=ms-sql-dump-hashes,ms-sql-empty-password,ms-sql-info,ms-sql-ntlm-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1434/udp" ]]; then
     hisServName="MS-SQL_UDP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p1434 --script-timeout 20s --script=ms-sql-dac --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1521/tcp" ]]; then
     thisServName="Oracle"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1521 --script-timeout 20s --script=oracle-tns-version,oracle-sid-brute --script oracle-enum-users --script-args oracle-enum-users.sid=ORCL,userdb=orausers.txt --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1604/udp" ]]; then
     thisServName="Citrix"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p1604 --script-timeout 20s --script=citrix-enum-apps,citrix-enum-servers --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1723/tcp" ]]; then
     thisServName="PPTP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1723 --script-timeout 20s --script=pptp-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1883/tcp" ]]; then
     thisServName="MQTT"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1883 --script-timeout 20s --script=mqtt-subscribe --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1911/tcp" ]]; then
     thisServName="Fox"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1911 --script-timeout 20s --script=fox-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "1962/tcp" ]]; then
     thisServName="PCWorx"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p1962 --script-timeout 20s --script=pcworx-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "2049/tcp" ]]; then
     thisServName="NFS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p2049 --script-timeout 20s --script=nfs-ls,nfs-showmount,nfs-statfs --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "2375/tcp" ]]; then
     thisServName="Docker"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p2375 --script-timeout 20s --script=docker-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "2628/tcp" ]]; then
     thisServName="DICT"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p2628 --script-timeout 20s --script=dict-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "2947/tcp" ]]; then
     thisServName="GPS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p2947 --script-timeout 20s --script=gpsd-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3031/tcp" ]]; then
     thisServName="EPPC"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p3031 --script-timeout 20s --script=eppc-enum-processes --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3260/tcp" ]]; then
     thisServName="iSCSI"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} $name/3260.txt -Pn -n --open -p3260 --script-timeout 20s --script=iscsi-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3306/tcp" ]]; then
     thisServName="MySQL"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p3306 --script-timeout 20s --script=mysql-databases,mysql-empty-password,mysql-info,mysql-users,mysql-variables --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3310/tcp" ]]; then
     thisServName="ClamAV"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p3310 --script-timeout 20s --script=clamav-exec --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3389/tcp" ]]; then
     thisServName="RDP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p3389 --script-timeout 20s --script=rdp-vuln-ms12-020,rdp-enum-encryption,rdp-ntlm-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3478/udp" ]]; then
     thisServName="STUN"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p3478 --script-timeout 20s --script=stun-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "3632/tcp" ]]; then
     thisServName="Distcc"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p3632 --script-timeout 20s --script=distcc-cve2004-2687 --script-args="distcc-exec.cmd='id'" --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "4369/tcp" ]]; then
     thisServName="EPMD"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p4369 --script-timeout 20s --script=epmd-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5019/tcp" ]]; then
     thisServName="Versant"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5019 --script-timeout 20s --script=versant-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5060/tcp" ]]; then
     thisServName="SIP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5060 --script-timeout 20s --script=sip-enum-users,sip-methods --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5353/udp" ]]; then
     thisServName="mDNS"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p5353 --script-timeout 20s --script=dns-service-discovery --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5666/tcp" ]]; then
     thisServName="Nagios"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5666 --script-timeout 20s --script=nrpe-enum --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5672/tcp" ]]; then
     thisServName="AMQP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5672 --script-timeout 20s --script=amqp-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5683/udp" ]]; then
     thisServName="CoAP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p5683 --script-timeout 20s --script=coap-resources --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5850/tcp" ]]; then
     thisServName="OpenLookup"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5850 --script-timeout 20s --script=openlookup-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5900/tcp" ]]; then
     thisServName="VNC"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5900 --script-timeout 20s --script=realvnc-auth-bypass,vnc-info,vnc-title --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "5984/tcp" ]]; then
     thisServName="CouchDB"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p5984 --script-timeout 20s --script=couchdb-databases,couchdb-stats --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "6000/tcp" ]] || [[ ${thisPort} = "6001/tcp" ]] || [[ ${thisPort} = "6002/tcp" ]] || [[ ${thisPort} = "6003/tcp" ]] || [[ ${thisPort} = "6004/tcp" ]] || [[ ${thisPort} = "6005/tcp" ]]; then
     thisServName="X11"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          nmap ${thisHost} -Pn -n --open -p6000-6005 --script-timeout 20s --script=x11-access --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi

if [[ ${thisPort} = "6379/tcp" ]]; then
     thisServName="Redis"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p6379 --script-timeout 20s --script=redis-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "7634/tcp" ]]; then
     thisServName="HDDTemp"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p7634 --script-timeout 20s --script=hddtemp-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "8000/tcp" ]]; then
     thisServName="QCONN"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p8000 --script-timeout 20s --script=qconn-exec --script-args=qconn-exec.timeout=60,qconn-exec.bytes=1024,qconn-exec.cmd="uname -a" --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "8009/tcp" ]]; then
     thisServName="AJP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p8009 --script-timeout 20s --script=ajp-methods,ajp-request --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "8081/tcp" ]]; then
     thisServName="McAfee-ePO"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p8081 --script-timeout 20s --script=mcafee-epo-agent --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "8091/tcp" ]]; then
     thisServName="CouchBase"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p8091 --script-timeout 20s --script=membase-http-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "8140/tcp" ]]; then
     thisServName="Puppet"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p8140 --script-timeout 20s --script=puppet-naivesigning --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "8322/tcp" ]] || [[ ${thisPort} = "8333/tcp" ]]; then
     thisServName="Bitcoin"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p8332,8333 --script-timeout 20s --script=bitcoin-getaddr,bitcoin-info,bitcoinrpc-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "9100/tcp" ]]; then
     thisServName="Lexmark"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p9100 --script-timeout 20s --script=lexmark-config --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "9600/tcp" ]]; then
     thisServName="Omron"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p9600 --script-timeout 20s --script=omron-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "9999/tcp" ]]; then
     thisServName="JDWP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p9999 --script-timeout 20s --script=jdwp-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "10000/tcp" ]]; then
     thisServName="NDMP"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p10000 --script-timeout 20s --script=ndmp-fs-info,ndmp-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "11211/tcp" ]]; then
     thisServName="Memcached"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p11211 --script-timeout 20s --script=memcached-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "12345/tcp" ]]; then
     thisServName="NetBus"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p12345 --script-timeout 20s --script=netbus-auth-bypass,netbus-version --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "19150/tcp" ]]; then
     thisServName="Gkrellm"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p19150 --script-timeout 20s --script=gkrellm-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "27017/tcp" ]]; then
     thisServName="MongoDB"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p27017 --script-timeout 20s --script=mongodb-databases,mongodb-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "31337/udp" ]]; then
     thisServName="BackOrifice"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p31337 --script-timeout 20s --script=backorifice-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "44818/udp" ]]; then
     thisServName="EtherNet-IP-2"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p44818 --script-timeout 20s --script=enip-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "47808/udp" ]]; then
     thisServName="BACnet"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     sudo nmap ${thisHost} -Pn -n -sU --open -p47808 --script-timeout 20s --script=bacnet-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "49152/tcp" ]]; then
     thisServName="Supermicro"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     nmap ${thisHost} -Pn -n --open -p49152 --script-timeout 20s --script=supermicro-ipmi-conf --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
fi

if [[ ${thisPort} = "50030/tcp" ]] || [[ ${thisPort} = "50060/tcp" ]] || [[ ${thisPort} = "50070/tcp" ]] || [[ ${thisPort} = "50075/tcp" ]] || [[ ${thisPort} = "50090/tcp" ]]; then
     thisServName="Hadoop"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          nmap ${thisHost} -Pn -n --open -p50030,50060,50070,50075,50090 --script-timeout 20s --script=hadoop-datanode-info,hadoop-jobtracker-info,hadoop-namenode-info,hadoop-secondary-namenode-info,hadoop-tasktracker-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi

if [[ ${thisPort} = "60010/tcp" ]] || [[ ${thisPort} = "60030/tcp" ]]; then
     thisServName="HBase"
     printf "%(%F %T)T [%s] [%s] %s\n" -1 "Recon" "Info" "${thisHost}  ${thisPort}  ${thisServName}"
     thisFileName="${thisHost}_${thisServName}"
     if [[ ! -e ${thisFileName}.nmap ]]; then
          nmap ${thisHost} -Pn -n --open -p60010,60030 --script-timeout 20s --script=hbase-master-info,hbase-region-info --min-hostgroup 100 -oX ${outDir}/xml/${thisFileName}.xml >${outDir}/${thisFileName}.nmap
     fi
fi
