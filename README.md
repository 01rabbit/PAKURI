# PAKURI: Penetration Test Achieve Knowledge Unite Rapid Interface

![logo](img/pakuri-banner.png)  
![version](https://img.shields.io/github/v/tag/01rabbit/PAKURI?label=Version)
![License](https://img.shields.io/github/license/01rabbit/PAKURI)
![release-date](https://img.shields.io/github/release-date/01rabbit/PAKURI)
![sns](https://img.shields.io/twitter/follow/PAKURI9?label=PAKURI&style=social)
![BHASIA](https://img.shields.io/badge/BlackHat%20Asia%202020-Arsenal-red)

---

## PAKURI has been merged with Python and launched as a new project, [PAKURI-THON](https://github.com/01rabbit/PAKURI-THON).

## Overview

PAKURI is a penetration test tool with a terminal user interface (TUI) that can be operated with just the keypad.

![overview](https://user-images.githubusercontent.com/16553787/93030592-19005680-f65f-11ea-8d8c-8216bdb43bb5.png)  

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

---

## Description

PAKURI is a semi-automated, user-friendly framework for penetration testing tools. Using only the keypad, you can use the penetration test tool like a game.  
It's also a great introductory tool for beginners. Learn the flow of penetration testing with PAKURI without having to wrestle with confusing command lines and tools.

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
* Enumeration
  * [enum4linux](https://tools.kali.org/information-gathering/enum4linux)
  * [Nikto](https://tools.kali.org/information-gathering/nikto)
  * [sslscan](https://github.com/rbsec/sslscan)
  * [SSLyze](https://tools.kali.org/information-gathering/sslyze)

### Vulnerability analysis

* Vulnerability Scan
  * [OpenVAS](https://tools.kali.org/vulnerability-analysis/openvas)

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
  PAKURI can be operated with CUI and does not require a high-spec machine, so it can be operated with Raspberry Pi.

---

## Setup

1. Update your apt and install git:  

    ```shell
    kali@kali:~$ sudo apt update
    kali@kali:~$ sudo apt install git
    ```

2. PAKURI uses the Docker. If you don't have it installed, you can install it by following the steps below.

    1. Install Docker. (I've been promoted to administrator privileges to reduce the amount of work involved.
  Add the GPG key from the official Docker repository to the system.

        ```shell
        root@kali:/home/kali# curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        ```

    2. Add the Docker repository to the APT source. (kali base debian)

        ```shell
        root@kali:/home/kali# echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' > /etc/apt/sources.list.d/docker.list
        ```

    3. Update the repository and install docker-ce and docker-compose.

        ```shell
        kali@kali:~$ sudo apt update
        kali@kali:~$ sudo apt install docker-ce -y
        kali@kali:~$ sudo apt install docker-compose -y
        ```

3. Download the PAKURI installer from the PAKURI Github repository:

    ```shell
    kali@kali:~$ git clone https://github.com/01rabbit/PAKURI.git
    ```

4. CD into the PAKURI folder and run the setup script:

    ```shell
    kali@kali:~$ cd PAKURI  
    kali@kali:~/PAKURI$ chmod +x setup.sh
    kali@kali:~/PAKURI$ ./setup.sh
    ```

5. Install OpenVAS/GVM if haven’t done so:  

    ```shell
    sudo apt install -y openvas
    or
    sudo apt install -y gvm
    ```  

6. Initialize Faraday if you haven't done so:  

    ```shell
    sudo systemctl start postgresql
    sudo faraday-manage initdb | tee faraday-setup.log
    ```

7. Include the credentials in pakuri.conf:

    ```shell
    kali@kali:~/PAKURI$ vim pakuri.conf
    ...snip...

    # OpenVAS
    OMPUSER="admin"
    OMPPASS="admin"
    ```

8. Faraday-server is started. After starting up, access from your browser and register your workspace:

    ```shell
    kali@kali:~/PAKURI$ systemctl start faraday.service  
    kali@kali:~/PAKURI$ firefox localhost:5985
    ```

9. Register the workspace you just registered in pakuri.conf:

    ```shell
    kali@kali:~/PAKURI$ vim pakuri.conf
    ...snip...

    # Faraday
    WORKSPACE="test_workspace"
    ```

---

## Usage

```shell
kali@kali:~/PAKURI$ ./pakuri.sh
```

PAKURI is not fully automated and requires the user interactions, to make sure to proceed the pentest and to avoid any unintended attack or trouble.  

---

## Operation check environment

* OS: KAli Linux 2020.1
* Memory: 8.0GB

## Known Issues

* This is intended for use Kali Linux. Operation on other OS is not guaranteed.  
* Due to major changes in OpenVAS, the commands used have changed. This will be fixed in the next version.

---

## Contributors

If you have some new idea about this project, issue, feedback or found some valuable tool feel free to open an issue for just DM me via [@Mr.Rabbit](https://twitter.com/01ra66it) or [@PAKURI](https://twitter.com/PAKURI9).

---

### Presentation
* Black Hat:
  * Asia ![](https://raw.github.com/wiki/infobyte/faraday/images/flags/singapore.png):
  [2020](https://www.blackhat.com/asia-20/arsenal/schedule/index.html#pakuri-penetration-test-achieve-knowledge-unite-rapid-interface-19270)

* AVTokyo ![](https://raw.github.com/wiki/infobyte/faraday/images/flags/japan.png):
    [2019](http://en.avtokyo.org/avtokyo2019/event) -
    [2020](http://en.avtokyo.org/avtokyo2020/event)

* SECCON ![](https://raw.github.com/wiki/infobyte/faraday/images/flags/japan.png):
   [2019](https://www.seccon.jp/2019/akihabara/#yorozu)

### Special thanks

Thanks to [@cyberdefense_jp](https://twitter.com/cyberdefense_jp) for contribute so many awesome ideas to this tool.  
***Please note that I have nothing to do with CDI. I just respect them on my own.***
