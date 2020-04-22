# PAKURI: Penetration Test Achieve Knowledge Unite Rapid Interface

![logo](img/pakuri-banner.png)  
![version](https://img.shields.io/github/v/tag/01rabbit/PAKURI?label=Version)
![License](https://img.shields.io/github/license/01rabbit/PAKURI)
![release-date](https://img.shields.io/github/release-date/01rabbit/PAKURI)
![sns](https://img.shields.io/twitter/follow/PAKURI9?label=PAKURI&style=social)

---

[Japanese](README_ja.md)

## Overview

PAKURI is a penetration test tool with a terminal user interface (TUI) that can be operated with just the keypad.

### What's PAKURI

I've consulted many pen testing tools. I then took the good points of those tools and incorporated them into my own tools. In Japanese slang, imitation is also called "paku-ru".
> ぱくる (godan conjugation, hiragana and katakana パクる, rōmaji pakuru)
>
> 1. eat with a wide open mouth
> 2. steal when one isn't looking, snatch, swipe  
> 3. copy someone's idea or design  
> 4. nab, be caught by the police  
>
> [Wiktionary:ぱくる](https://en.wiktionary.org/wiki/%E3%81%B1%E3%81%8F%E3%82%8B "ぱくる")

## Description

Sometimes, the penetration testers love to perform a complicated job. However, I always prefer the easy way. PAKURI is an semi-automated user-friendly penetration testing tool framework. You can run the popular pentest tools using only the numeric keypad, just like a game. It is also a good entry tool for the beginners. They can use PAKURI to learn the flow to the penetration testing without struggling with a confusing command line/tools.

---

## Presentation

* November 2nd,2019: [AV TOKYO 2019 Hive](http://ja.avtokyo.org/avtokyo2019/event)
* December 21-22th,2019: [SECCON YOROZU 2019](https://www.seccon.jp/2019/akihabara/)

---

## Your benefits

By using our PAKURI, you will benefit from the following.  

For redteam:  
  (a) Red Teams can easily perform operations such as information enumeration and vulnerability scanning.  
  (b) Visualizing the survey results is possible only with the numeric keypad.

For blueteam:  
  (c) The Blue Team can experience a dummy attack by simply operating the numeric keypad even they do not have any penetration testing skill.  

For beginner:  
  (d) PAKURI has been created to support the early stages of penetration testing. These can be achieved with what is included in Kali-Tools. It can be useful for training the entry level pentesters.

|**NOTE**  |
|:----------------|
|If you are interested, please use them in an environment **under your control and at your own risk**. And, if you execute the PAKURI on systems that are not under your control, it may be considered an attack and you may have legally liabillity for your action.|

---

## Features

### Intelligence gathering

* Port Scan
  * [Nmap](https://tools.kali.org/information-gathering/nmap)
  * [nmap_vulners](https://github.com/vulnersCom/nmap-vulners)
* Enumeration
  * [enum4linux](https://tools.kali.org/information-gathering/enum4linux)
  * [Nikto](https://tools.kali.org/information-gathering/nikto)
  * [sslscan](https://github.com/rbsec/sslscan)
  * [SSLyze](https://tools.kali.org/information-gathering/sslyze)

### Vulnerability analysis

* Vulnerability Scan
  * [OpenVAS](https://tools.kali.org/vulnerability-analysis/openvas)
* Web Application Scan
  * [Skipfish](https://tools.kali.org/web-applications/skipfish)

### Exploit

* Brute Force Attack
  * [BruteSpray](https://tools.kali.org/password-attacks/brutespray)
* Exploitation
  * [Metasploit](https://tools.kali.org/exploitation-tools/metasploit-framework)
  * Exsploit Database - [searchsploit](https://tools.kali.org/exploitation-tools/exploitdb)

### Misc

* Visualize
  * [Faraday](https://github.com/infobyte/faraday.git)
* CUI-GUI switching
  * PAKURI can be operated with CUI and does not require a high-spec machine, so it can be operated with Raspberry Pi.

---

## Install

1. Update your apt and install git:  

    ```shell
    kali@kali:~$ sudo apt update
    kali@kali:~$ sudo apt install git
    ```

2. Download the PAKURI installer from the PAKURI Github repository:

    ```shell
    kali@kali:~$ git clone https://github.com/01rabbit/PAKURI.git
    ```

3. CD into the PAKURI folder and run the install script:

    ```shell
    kali@kali:~$ cd PAKURI  
    kali@kali:~/PAKURI$ chmod +x install.sh
    kali@kali:~/PAKURI$ sudo ./install.sh
    ```

---

## Usage

1. Register the OpenVAS administrator user and password in pakuri.conf:

    ```shell
    kali@kali:~/PAKURI$ vim pakuri.conf
    ...snip...

    # OpenVAS
    OMPUSER="admin"
    OMPPASS="admin"
    ```

2. Faraday-server is started. After starting up, access from your browser and register your workspace:

    ```shell
    kali@kali:~/PAKURI$ sudo systemctl start faraday-server.service  
    kali@kali:~/PAKURI$ firefox localhost:5985
    ```

3. Register the workspace you just registered in pakuri.conf:

    ```shell
    kali@kali:~/PAKURI$ vim pakuri.conf
    ...snip...

    # Faraday
    WORKSPACE="test_workspace"
    ```

4. Start PAKURI:

    ```shell
    kali@kali:~/PAKURI$ ./pakuri.sh
    ```

   ![startup](https://user-images.githubusercontent.com/16553787/79108773-0c40a500-7d45-11ea-9cf3-fe01cdc1df97.gif)
PAKURI is not fully automated and requires the user interactions, to make sure to proceed the pentest and to avoid any unintended attack or trouble.  

---

## Keypad Operation

![keypad_op](https://user-images.githubusercontent.com/16553787/79107440-5f652880-7d42-11ea-9206-fbc9908089a1.gif)  
By operating the numeric keypad, it is possible to scan the network, scan for vulnerabilities, and perform simple pseudo attacks.

### Keypad Operation DEMO

Main > [1]Scanning > [1]Port Scan > [1]Port Scan > [1]Yes  
![scan](https://user-images.githubusercontent.com/16553787/79178611-a0dbfd80-7e40-11ea-8132-0d9a07d62750.gif)

---

## Operation check environment

* OS: KAli Linux 2020.1
* Memory: 8.0GB

## Known Issues

This is intended for use Kali Linux. Operation on other OS is not guaranteed.

---

## Contributors

If you have some new idea about this project, issue, feedback or found some valuable tool feel free to open an issue for just DM me via [@Mr.Rabbit](https://twitter.com/01ra66it) or [@PAKURI](https://twitter.com/PAKURI9).

### Special thanks

Thanks to [@cyberdefense_jp](https://twitter.com/cyberdefense_jp) for contribute so many awesome ideas to this tool.
