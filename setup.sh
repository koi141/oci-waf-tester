#!/bin/bash


# 事前確認
echo '=========================================================='
echo '[*] Setting up the WAF test environment...'
if [[ -f "./config/target.cfg" ]]; then
    source ./config/target.cfg
else
    touch ./config/target.cfg
fi


# 環境設定
echo '----------------------------------------------------------'
read -p "  1. TARGET_HOST [${TARGET_HOST:-" "}] = " host
host="${host:-${TARGET_HOST:-}}"
read -p "  2. TARGET_PORT [${TARGET_PORT:-" "}] = " port
port="${port:-${TARGET_PORT:-}}"
echo '----------------------------------------------------------'

cat >"./config/target.cfg" <<EOF
# Server Info
TARGET_HOST="${host}"
TARGET_PORT="${port}"
EOF

url=http://${host}:${port}/

# 接続確認
echo
echo '[*] Testing connectivity to the target...'
if code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 5 "${url}")"; then
    echo "[✓] Connectivity OK  -> ${url} (HTTP ${code})"
    echo '[+] Setup completed. Configuration saved to target.cfg.'
    echo '=========================================================='
    echo
else
    echo "[!] Unable to connect to ${url}"
    exit 1
fi