#!/bin/bash

# 创建用户（如果不存在）
if ! id "$SSH_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$SSH_USER"
fi

# 设置密码
echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

# 确保用户有 sudo 权限（可选）
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 启动 supervisor
exec /usr/bin/supervisord -n