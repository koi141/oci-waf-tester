# OCI WAF Hands-on Tester
ハンズオンにおける、OCI WAF の動作を簡単に確認するためのテストツールです。  
DoS, SQL Injection, XSS のシミュレーションを実行し、WAFが正常にブロックするかどうかを確認できます。

## ⚠️ 注意事項

本ツールはハンズオンでの使用を目的とした、 **学習・検証目的専用** です。  
ご自身の管理下にないサーバーや、本番環境に対しては使用しないでください。本ツールの使用によって生じたいかなるトラブルや損失についても、作成者は責任を負いません。  


## 1. 構成
```
├── README.md
├── attacks                       # 攻撃スクリプト
│   ├── dos.sh
│   ├── sqli.sh
│   └── xss.sh
├── config                        # 設定ファイル
│   ├── attacks.cfg
│   └── taget.cfg
├── responseFile
│   ├── sorryPage.html            # Sorry Page
│   └── sorryPageCompressed.html  # 圧縮した Sorry Page
├── setup.sh                      # Set Upスクリプト
└── waf-test.sh                   # メインコマンド
```

## 2. 準備
本ツールは `waf-test.sh` をメインコマンドにして行います。

リポジトリをクローンします。
```
git clone https://github.com/koi141/oci-waf-tester
```

関連するスクリプトに実行権限を付与します。
```
chmod +x waf-test.sh setup.sh attacks/*.sh
```

## 3. 使い方
### 3.1. インタラクティブメニュー

引数なしで実行すると、メニューが表示されます。
```
$ ./waf-test.sh 
----------------------------------------------------------
- [0]: setup - WAF テスト環境のセットアップ
- [1]: dos   - DoS 攻撃シミュレーション
- [2]: sqli  - SQL Injection 攻撃シミュレーション
- [3]: xss   - XSS 攻撃シミュレーション
- [q]: quit  - 終了
----------------------------------------------------------
Select a Menu: 
```

### 3.2. セットアップ
メニューから、`0` または `setup` を入力し、テスト対象のホストとポートを設定します。
```
...
Select a command: 0

==========================================================
[*] Setting up the WAF test environment...
----------------------------------------------------------
  1. TARGET_HOST [ ] = xxx.xxx.xxx.xxx
  2. TARGET_PORT [80] = 80
----------------------------------------------------------
...
```

なお、`config/taget.cfg` を直接編集して設定することも可能です。
```
# Server Info
TARGET_HOST="<hostname>"
TARGET_PORT="80"
```

### 3.3. DoS シミュレーション
50 リクエストを並列で送信し、HTTP ステータスを確認します。
攻撃を開始する前に、サーバーにテスト用リクエストを送信し、正しく通信されるかを確認します。
「`[!] Unable to connect to http://xxx.xxx.xxx.xxx:80`」と表示された場合は、サーバー環境設定が正しくされているかどうかをご確認ください。

```
...
Select a Menu: 1

==========================================================
[*] DoS Attack Simulation
----------------------------------------------------------
 Target Info
   HOST : xxx.xxx.xxx.xxx
   PORT : 80
----------------------------------------------------------
[*] Pre-checking the target...
[✓] Connectivity OK  -> http://xxx.xxx.xxx.xxx:80 (HTTP 200)

[*] 攻撃を開始しますか？ (y/n): y
[*] Running DoS simulation: 50 requests to xxx.xxx.xxx.xxx
...
```

### 3.4. SQLi / XSS シミュレーション
計5回の攻撃リクエストを送信し、成功 (200) か WAF ブロック (401) を表示します。
攻撃を開始する前に、サーバーにテスト用リクエストを送信し、正しく通信されるかを確認します。
「`[!] Unable to connect to http://xxx.xxx.xxx.xxx:80`」と表示された場合は、サーバー環境設定が正しくされているかどうかをご確認ください。

```
Select a Menu: 2

==========================================================
[*] SQL Injection Simulation
----------------------------------------------------------
 Target Info
   HOST : xxx.xxx.xxx.xxx
   PORT : 80
----------------------------------------------------------
[*] Pre-checking the target...
[✓] Connectivity OK  -> http://xxx.xxx.xxx.xxx:80 (HTTP 200)

[*] 攻撃を開始しますか？ (y/n): y
[*] Sending SQL Injection payload...
...
```

### 3.5. 直接コマンドで実行
上記の実行はサブコマンド形式でも利用することが可能です。
```
./waf-test.sh setup
./waf-test.sh dos
./waf-test.sh sqli
./waf-test.sh xss
```


## 4. その他
- プロコトルはHTTPを想定しています
    - `http://${TARGET_HOST}:${TARGET_PORT}`へのアクセスします
- Block時の設定は `Pre-configured 401 Response Code Action` が設定されていることを想定しています。
    - そのため、401コードが帰ることにより、WAFによりBlockされたと判定しています。
