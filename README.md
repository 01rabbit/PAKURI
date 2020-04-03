# PAKURI

![logo](img/pakuri-banner.png)
![version](https://img.shields.io/github/v/tag/01rabbit/PAKURI?label=Version)
![License](https://img.shields.io/github/license/01rabbit/PAKURI)
![release-date](https://img.shields.io/github/release-date/01rabbit/PAKURI)
![sns](https://img.shields.io/twitter/follow/PAKURI9?label=PAKURI&style=social)

---

[Japanese](README_ja.md)

## What's PAKURI

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

* November 2nd,2019: [AV TOKYO 2018 Hive](http://ja.avtokyo.org/avtokyo2019/event)
* December 21-22th,2019: [SECCON YOROZU 2019](https://www.seccon.jp/2019/akihabara/)

---

## Abilities of "PAKURI"

* Intelligence gathering.
* Vulnerability analysis.
* Visualize.
* Brute Force Attack.
* Exploitation.

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

* Scan
  * [enum4linux](https://tools.kali.org/information-gathering/enum4linux)
  * [Nikto](https://tools.kali.org/information-gathering/nikto)
  * [Nmap](https://tools.kali.org/information-gathering/nmap)
  * [OpenVAS](https://tools.kali.org/vulnerability-analysis/openvas)
  * [Skipfish](https://tools.kali.org/web-applications/skipfish)
  * [sslscan](https://github.com/rbsec/sslscan)
  * [SSLyze](https://tools.kali.org/information-gathering/sslyze)

* Exploit
  * [BruteSpray](https://tools.kali.org/password-attacks/brutespray)
  * [Metasploit](https://tools.kali.org/exploitation-tools/metasploit-framework)
* Visualize
  * [Faraday](https://github.com/infobyte/faraday.git)
* CUI-GUI switching
  * PAKURI can be operated with CUI and does not require a high-spec machine, so it can be operated with Raspberry Pi.

---

## Install

1. Update your apt and install git:  

    ```shell
    root@kali:~# apt update
    root@kali:~# apt install git
    ```

2. Download the PAKURI installer from the PAKURI Github repository:

    ```shell
    root@kali:~# git clone https://github.com/01rabbit/PAKURI.git
    ```

3. CD into the PAKURI folder and run the install script:

    ```shell
    root@kali:~# cd PAKURI  
    root@kali:~/PAKURI# bash install.sh
    ```

---

## Usage

1. Check the OpenVAS admin user and password set them in the pakuri.conf file:

    ```shell
    root@kali:~# vim /usr/share/PAKURI/pakuri.conf
    ...snip...

    # OpenVAS
    OMPUSER="admin"
    OMPPASS="admin"
    ```

2. Start Faraday-Server and set workspace:

    ```shell
    root@kali:~# systemctl start faraday-server.service  
    root@kali:~# firefox localhost:5985
    ```

3. Set Workspace in the pakuri.conf file.

    ```shell
    root@kali:~# vim /usr/share/PAKURI/pakuri.conf
    ...snip...

    # Faraday
    WORKSPACE="test_workspace"
    ```

4. CD into the PAKURI folder:

    ```shell
    root@kali:~# cd /usr/share/PAKURI
    ```

5. Start PAKURI:

    ```shell
    root@kali:/usr/share/PAKURI# ./pakuri.sh
      ____ ____ ____ ____ ____ ____
     ||P |||A |||K |||U |||R |||I ||
     ||__|||__|||__|||__|||__|||__||
     |/__\|/__\|/__\|/__\|/__\|/__\|
                              v1.1.0
                 Author  : Mr.Rabbit
                     inspired by CDI

     Workspace: demo
     ---------- Main Menu -----------
     +---+
     | 1 | Scanning
     +---+
     +---+
     | 2 | Exploit
     +---+
     +---+
     | 3 | Config
     +---+
     +---+
     | 4 | Assist
     +---+
     +---+
     | 9 | Back
     +---+
    ```

PAKURI is not fully automated and requires the user interactions, to make sure to proceed the pentest and to avoid any unintended attack or trouble.

### Scanning

![scanning](https://user-images.githubusercontent.com/16553787/71568958-dc132480-2b0e-11ea-97b0-13989b045ce2.png)

### Exploit

![exploit](https://user-images.githubusercontent.com/16553787/71568975-0238c480-2b0f-11ea-9092-010b78e34bd1.png)

### Config

![config](https://user-images.githubusercontent.com/16553787/71568995-1ed4fc80-2b0f-11ea-9afe-315a055b8a76.png)

By operating the numeric keypad, it is possible to scan the network, scan for vulnerabilities, and perform simple pseudo attacks.

---

## Operation check environment

* OS: KAli Linux 2019.4
* Memory: 8.0GB

## Known Issues

This is intended for use Kali Linux. Operation on other OS is not guaranteed.

---

## Contributors

If you have some new idea about this project, issue, feedback or found some valuable tool feel free to open an issue for just DM me via [@Mr.Rabbit](https://twitter.com/01ra66it) or [@PAKURI](https://twitter.com/PAKURI9).

### Special thanks

Thanks to [@cyberdefense_jp](https://twitter.com/cyberdefense_jp) for contribute so many awesome ideas to this tool.
