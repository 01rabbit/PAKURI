# PAKURI

![logo](https://user-images.githubusercontent.com/16553787/70399114-c4db9c80-1a64-11ea-8d8e-5cf2f4f43ee0.png)

---

## What's PAKURI

I have imitated the good points of many tools.  In Japanese, imitating is called “Pakuru”.
> ぱくる (godan conjugation, hiragana and katakana パクる, rōmaji pakuru)
>
> 1. eat with a wide open mouth
> 2. steal when one isn't looking, snatch, swipe  
> 3. copy someone's idea or design  
> 4. nab, be caught by the police  
>
> [Wiktionary:ぱくる](https://en.wiktionary.org/wiki/%E3%81%B1%E3%81%8F%E3%82%8B "ぱくる")

## Description

Pentesters love to move their hands. However, I do not like troublesome work. Simple work is performed semi-automatically with simple operations. PAKURI executes commands frequently used in penetration tests by simply operating the numeric keypad. You can test penetration as if you were playing a fighting game.

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
  (a) This saves you the trouble of entering frequently used commands.  
  (b) Beginner pentester can learn the floe of attacks using PAKURI.

For blueteam:  
  (c) Attack packets can be generated with a simple operation.  

|**NOTE**  |
|:----------------|
|If you are interested, please use them in an environment **under your control and at your own risk**. And, if you execute the PAKURI on systems that are not under your control, it may be considered an attack and you may have legally liabillity for your action.|

---

## Features

* Scan
  * [Nmap](https://tools.kali.org/information-gathering/nmap)
  * [AutoRecon](https://github.com/Tib3rius/AutoRecon.git)
  * [OpenVAS](https://tools.kali.org/vulnerability-analysis/openvas)
* Exploit
  * [BruteSpray](https://tools.kali.org/password-attacks/brutespray)
  * [Metasploit](https://tools.kali.org/exploitation-tools/metasploit-framework)
* Visualize
  * [Faraday](https://github.com/infobyte/faraday.git)
* CUI-GUI switching
  * PAKURI can be used with Raspberry Pi. However, Raspberry Pi doesn't have much memory. Therefore, you can switch to CUI to reduce memory consumption.

---

## Install

1. Update your apt and install git:  

    ```
    root@kali:~# apt update
    root@kali:~# apt install git
    ```

2. Download the PAKURI installer from the PAKURI Github repository:

    ```
    root@kali:~# git clone https://github.com/01rabbit/PAKURI.git
    ```

3. CD into the PAKURI folder and run the install script:

    ```
    root@kali:~# cd PAKURI  
    root@kali:~/PAKURI# bash install.sh
    ```

---

## Usage

1. Check the OpenVAS's admin user and password set them in the .config file:

    ```
    root@kali:~# vim /usr/share/pakuri/.config
    ...snip...

    # OpenVAS
    OMPUSER="admin"
    OMPPASS="admin"
    ```

2. Start Faraday-Server and set workspace:

    ```
    root@kali:~# systemctl start faraday-server.service  
    root@kali:~# firefox localhost:5985
    ```
3. CD into the pakuri folder:

    ```
    root@kali:~# cd /usr/share/pakuri
    ```

4. Start PAKURI:

    ```
    root@kali:/usr/share/pakuri#./pakuri.sh

    ██████╗   █████╗    ██╗  ██╗   ██╗   ██╗   ██████╗    ██╗
    ██╔══██╗ ██╔══██╗   ██║ ██╔╝   ██║   ██║   ██╔══██╗   ██║
    ██████╔╝ ███████║   █████╔╝    ██║   ██║   ██████╔╝   ██║
    ██╔═══╝  ██╔══██║   ██╔═██╗    ██║   ██║   ██╔══██╗   ██║
    ██║   ██╗██║  ██║██╗██║  ██╗██╗╚██████╔╝██╗██║  ██║██╗██║
    ╚═╝   ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝╚═╝

    - Penetration Test Achive Knowledge Unite Rapid Interface -
                        inspired by CDI
    
                                                          v1.0.2
                                              Author  : Mr.Rabbit
    
    Fri 20 Dec 2019 22:25:07 PM JST
    Working Directory : /root/demo
    ---------------------- Main Menu -----------------------
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

### Scanning

![scanning](https://user-images.githubusercontent.com/16553787/70430090-570f8f00-1abd-11ea-956e-656d24b5e2f4.png)

### Exploit

![exploit](https://user-images.githubusercontent.com/16553787/70430110-668ed800-1abd-11ea-8df5-051b2bcebd90.png)

### Config

![config](https://user-images.githubusercontent.com/16553787/70430127-71496d00-1abd-11ea-8801-8d45383d6ee6.png)

### Command

![usage1](https://user-images.githubusercontent.com/16553787/70429539-1a8f6380-1abc-11ea-992f-9bb1e57fc8bf.png)
![usage2](https://user-images.githubusercontent.com/16553787/70429582-2d099d00-1abc-11ea-8ae8-2ea2c75b9a8b.png)

## Operation check environment

* OS: KAli Linux 2019.4
* Memory: 8.0GB

## Known Issues

This is intended for use Kali Linux. Operation on other OS is not guaranteed.

---

## Support

Feature request / bug reports: https://github.com/01rabbit/PAKURI/issues
