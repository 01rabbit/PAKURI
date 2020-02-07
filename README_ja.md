# PAKURI

![logo](https://user-images.githubusercontent.com/16553787/70399114-c4db9c80-1a64-11ea-8d8e-5cf2f4f43ee0.png)
![version](https://img.shields.io/github/v/tag/01rabbit/PAKURI?label=Version)
![License](https://img.shields.io/github/license/01rabbit/PAKURI)
![release-date](https://img.shields.io/github/release-date/01rabbit/PAKURI)
![sns](https://img.shields.io/twitter/follow/PAKURI9?label=PAKURI&style=social)

---

[English](README.md)

## PAKURIとは

私は多くのツールの良い点を模倣しました。 日本語の俗語で、模倣は「パクる」と言います。  
> ぱくる（異綴：パクる）
>
> 1. ぱくぱくと食べる。大きな口を開けて食べる。
> 2. （俗語）隙をついて金品をかっさらう。金銭や料金を横領する。
> 3. （俗語）盗用する。
> 4. （俗語）警察などが人をつかまえ、捕縛する。  
>
> [Wiktionary:ぱくる](https://ja.wiktionary.org/wiki/%E3%81%B1%E3%81%8F%E3%82%8B "ぱくる")

## 説明

ペンテスターは手を動かすことが大好きです。しかし、面倒くさい作業は好きではありません。簡易的な作業は、簡単な操作で半自動実行します。PAKURIは、作業で頻繁に使用するコマンドをテンキーの操作だけで実行します。まるで格闘ゲームをやっているような感覚でペネトレーションテストができます。  
PAKURIはペネトレーションテストのキャリアを開始するのにも役に立ちます。Kali-Toolsに準拠するツールを使用しているので必要以上に破壊することはしません。ビギナーは、PAKURIを使用することで、ペネトレーションテストのフローを簡単に体験し成長する事でしょう。

---

## 過去の発表

* November 2nd,2019: [AV TOKYO 2018 Hive](http://ja.avtokyo.org/avtokyo2019/event)
* December 21-22th,2019: [SECCON YOROZU 2019](https://www.seccon.jp/2019/akihabara/)

---

## PAKURIの能力

* 情報収集
* 脆弱性スキャン
* 可視化
* 総当たり攻撃（ブルートフォース）
* 脆弱性の悪用

---

## 利点

PAKURIを使用する利点  

レッドチームの場合:  
  (a) レッドチームは、情報の列挙や脆弱性スキャンなどの操作を簡単に実行できます。  
  (b) テンキー操作のみで、調査結果の可視化が可能です。

ブルーチームの場合:  
  (c) ブルーチームは、ペネトレーションテストのスキルが無くてもテンキーを操作するだけで攻撃を模倣することが可能です。  

初心者の場合:  
  (d) PAKURIは、ペネトレーションテストの初期段階をサポートするために作成されました。また、本ツールは「Kali-Tools」に収録されているツールで構成されています。ペンテストを始めたばかりの人のトレーニングに役立ちます。

|**注意**  |
|:----------------|
|もし、このツールに興味がある場合は、**自己の責任の下、自己の管理する環境**で使用してください。自己の管理外の環境でPAKURIを実行すると攻撃とみなされる可能性があり、法的責任を負う場合があります。|

---

## 特徴

* Scan
  * [Nmap](https://tools.kali.org/information-gathering/nmap)
  * [OpenVAS](https://tools.kali.org/vulnerability-analysis/openvas)
  * [AutoRecon](https://github.com/Tib3rius/AutoRecon.git)

* Exploit
  * [BruteSpray](https://tools.kali.org/password-attacks/brutespray)
  * [Metasploit](https://tools.kali.org/exploitation-tools/metasploit-framework)
* Visualize
  * [Faraday](https://github.com/infobyte/faraday.git)
* CUI-GUI switching
  * PAKURIはハイスペックなマシン性能を要求しないため、CUIでの操作が可能です。またRaspberry Piでも実行できます。

---

## インストール

1. aptのアップデートとgitのインストール:  

    ```shell
    root@kali:~# apt update
    root@kali:~# apt install git
    ```

2. PAKURIをGitHubリポジトリからダウンロード:

    ```shell
    root@kali:~# git clone https://github.com/01rabbit/PAKURI.git
    ```

3. PAKURIフォルダへ移動しインストールスクリプトを実行:

    ```shell
    root@kali:~# cd PAKURI  
    root@kali:~/PAKURI# bash install.sh
    ```

---

## 使い方

1. OpenVASの管理者とパスワードをpakuri.confファイルに設定:

    ```shell
    root@kali:~# vim /usr/share/PAKURI/pakuri.conf
    ...snip...

    # OpenVAS
    OMPUSER="admin"
    OMPPASS="admin"
    ```

2. Faraday-Serverを起動しworkspaceを設定:

    ```shell
    root@kali:~# systemctl start faraday-server.service  
    root@kali:~# firefox localhost:5985
    ```

3. 設定したWorkspaceをpakuri.confファイルに設定:

    ```shell
    root@kali:~# vim /usr/share/PAKURI/pakuri.conf
    ...snip...

    # Faraday
    WORKSPACE="test_workspace"
    ```

4. インストール先のPAKURIフォルダへ移動:

    ```shell
    root@kali:~# cd /usr/share/PAKURI
    ```

5. PAKURIの起動:

    ```shell
    root@kali:/usr/share/PAKURI# ./pakuri.sh

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

    Sun 29 Dec 2019 22:25:07 PM EST
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

PAKURIは完全に自動化されておらず、ペネトレーションテストを確実に進め、意図しない攻撃やトラブルを回避するために、ユーザーによる対話型の操作が必要です。

### Scanning

![scanning](https://user-images.githubusercontent.com/16553787/71568958-dc132480-2b0e-11ea-97b0-13989b045ce2.png)

### Exploit

![exploit](https://user-images.githubusercontent.com/16553787/71568975-0238c480-2b0f-11ea-9092-010b78e34bd1.png)

### Config

![config](https://user-images.githubusercontent.com/16553787/71568995-1ed4fc80-2b0f-11ea-9afe-315a055b8a76.png)

テンキーを操作することにより、ネットワークスキャン、脆弱性スキャンし、簡単な擬似攻撃を実行することができます。

---

## 検証環境

* OS: KAli Linux 2019.4
* Memory: 8.0GB

## 既知の問題

このツールは、Kali Linuxで使用するためのものです。 他のOSでの動作は保証されません

---

## サポート

機能追加要望 / バグ報告: <https://github.com/01rabbit/PAKURI/issues>
