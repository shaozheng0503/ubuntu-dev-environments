#!/bin/bash

# 设置默认值
SSH_USER=${SSH_USER:-ubuntu}
SSH_PASSWORD=${SSH_PASSWORD:-123456}

echo "Starting initialization with SSH_USER=$SSH_USER"

# 设置全局环境变量，确保 conda 环境在所有地方都可用
export PATH="/opt/miniconda3/bin:$PATH"
export CONDA_DEFAULT_ENV="base"

# 创建用户（如果不存在）
if ! id "$SSH_USER" &>/dev/null; then
    echo "Creating user: $SSH_USER"
    useradd -m -s /bin/bash "$SSH_USER"
    # 为新用户配置 conda 环境
    echo "source /opt/miniconda3/etc/profile.d/conda.sh && conda activate base" >> /home/$SSH_USER/.bashrc
    # 为新用户配置 pip 源
    mkdir -p /home/$SSH_USER/.pip && cp /root/.pip/pip.conf /home/$SSH_USER/.pip/pip.conf
    chown -R $SSH_USER:$SSH_USER /home/$SSH_USER
else
    echo "User $SSH_USER already exists"
fi

# 设置密码
echo "Setting password for user: $SSH_USER"
echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

# 确保用户有 sudo 权限（可选）
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# VSCode扩展已在构建阶段安装完成，无需运行时安装
echo "VSCode extensions already installed during build phase"

# 启动 supervisor
echo "Starting supervisord..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf