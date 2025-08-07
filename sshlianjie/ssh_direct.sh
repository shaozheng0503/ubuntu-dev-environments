#!/bin/bash

# 直接 SSH 连接脚本
# 使用方法: ./ssh_direct.sh [1|2]

SERVER1_IP="43.135.68.39"
SERVER2_IP="43.132.192.253"
USERNAME="root"
PASSWORD="8pA!5DRAq#"
PORT="22"

# 检查参数
if [ $# -eq 0 ]; then
    echo "使用方法: $0 [1|2]"
    echo "1 - 连接到服务器 1 (${SERVER1_IP})"
    echo "2 - 连接到服务器 2 (${SERVER2_IP})"
    exit 1
fi

case $1 in
    1)
        echo "连接到服务器 1: ${SERVER1_IP}"
        ssh -p ${PORT} ${USERNAME}@${SERVER1_IP}
        ;;
    2)
        echo "连接到服务器 2: ${SERVER2_IP}"
        ssh -p ${PORT} ${USERNAME}@${SERVER2_IP}
        ;;
    *)
        echo "无效参数，请使用 1 或 2"
        exit 1
        ;;
esac 