#!/bin/bash

main() {
    if [ $# -eq 0 ]; then
        while true; do
            echo '----------------------------------------------------------'
            echo '- [0]: setup - WAF テスト環境のセットアップ'
            echo '- [1]: dos   - DoS 攻撃シミュレーション'
            echo '- [2]: sqli  - SQL Injection 攻撃シミュレーション'
            echo '- [3]: xss   - XSS 攻撃シミュレーション'
            echo '- [q]: quit  - 終了'
            echo '----------------------------------------------------------'
            read -p 'Select a Menu: ' subcmd
            echo
            case ${subcmd} in
                0|setup)
                    ./setup.sh ;;
                1|dos)
                    ./attacks/dos.sh ;;
                2|sqli)
                    ./attacks/sqli.sh ;;
                3|xss)
                    ./attacks/xss.sh ;;
                q|quit|exit)
                    echo "[+] Exiting."
                    exit 0
                    ;;
                *)
                    echo "Invalid Option."
                    ;;
            esac
        done
    fi

    subcmd="$1"; shift
    case ${subcmd} in
        setup)
            shift
            ./setup.sh ;;
        dos)
            shift
            ./attacks/dos.sh ;;
        sqli)
            shift
            ./attacks/sqli.sh ;;
        xss)
            shift
            ./attacks/xss.sh ;;
        *)
            echo "Usage: $0 {setup|dos|sqli|xss}"
            exit 1
            ;;
    esac
}

main "$@"