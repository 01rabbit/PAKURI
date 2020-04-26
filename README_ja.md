# PAKURI

![logo](img/pakuri-banner.png)
![version](https://img.shields.io/github/v/tag/01rabbit/PAKURI?label=Version)
![License](https://img.shields.io/github/license/01rabbit/PAKURI)
![release-date](https://img.shields.io/github/release-date/01rabbit/PAKURI)
![sns](https://img.shields.io/twitter/follow/PAKURI9?label=PAKURI&style=social)

---

[English](README.md)

## PAKURIとは

私は多くのペンテストツールを参考にしました。そして、それらツールの良い点を参考にし自分のツールに組み込みました。 日本語の俗語で、模倣は「パクる」と言います。  
> ぱくる（異綴：パクる）
>
> 1. ぱくぱくと食べる。大きな口を開けて食べる。
> 2. （俗語）隙をついて金品をかっさらう。金銭や料金を横領する。
> 3. （俗語）盗用する。
> 4. （俗語）警察などが人をつかまえ、捕縛する。  
>
> [Wiktionary:ぱくる](https://ja.wiktionary.org/wiki/%E3%81%B1%E3%81%8F%E3%82%8B "ぱくる")

## 説明

PAKURIは半自動化されたユーザーフレンドリーなペネトレーションテストツールのフレームワークです。キーパッドだけを使いゲーム感覚でペネトレーションテストツールを使えます。
また、初心者の方の入門ツールとしても最適です。紛らわしいコマンドラインやツールと格闘することなく、PAKURIを使ってペネトレーションテストの流れを学ぶことができます。

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

## 貢献者

このプロジェクトについての新しいアイデアや、問題、フィードバック、または良いツールを見つけた場合は、[@Mr.Rabbit](https://twitter.com/01ra66it)または[@PAKURI](https://twitter.com/PAKURI9)へDMを送って下さい。

### Special thanks

このツールに素晴らしいアイデアを沢山提供してくれた[@cyberdefense_jp](https://twitter.com/cyberdefense_jp)に感謝します。
