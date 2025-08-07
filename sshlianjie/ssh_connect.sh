#!/bin/bash

# SSH 连接脚本
# 服务器信息
SERVER1_IP="43.135.68.39"
SERVER2_IP="43.132.192.253"
USERNAME="root"
PASSWORD="8pA!5DRAq#"
PORT="22"

echo "=== SSH 连接工具 ==="
echo "请选择要连接的服务器："
echo "1. 服务器 1 (${SERVER1_IP})"
echo "2. 服务器 2 (${SERVER2_IP})"
echo "3. 退出"
echo ""

read -p "请输入选择 (1-3): " choice

case $choice in
    1)
        echo "正在连接到服务器 1: ${SERVER1_IP}"
        ssh -p ${PORT} ${USERNAME}@${SERVER1_IP}
        ;;
    2)
        echo "正在连接到服务器 2: ${SERVER2_IP}"
        ssh -p ${PORT} ${USERNAME}@${SERVER2_IP}
        ;;
    3)
        echo "退出连接工具"
        exit 0
        ;;
    *)
        echo "无效选择，请重新运行脚本"
        exit 1
        ;;
esac 