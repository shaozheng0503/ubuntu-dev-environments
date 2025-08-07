#!/bin/bash
set -e

# 设置 root 密码
echo "root:${SSH_PASSWORD}" | chpasswd

# 生成 code-server 配置文件（无密码）
CONFIG_DIR="/root/.config/code-server"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
mkdir -p "${CONFIG_DIR}"

echo "生成 code-server 配置文件..."
cat <<EOF > "${CONFIG_FILE}"
bind-addr: 0.0.0.0:62661
auth: none
cert: false
EOF

# 设置 Jupyter Server 配置（无密码）
mkdir -p /root/.jupyter
cat <<EOF > /root/.jupyter/jupyter_server_config.py
c.ServerApp.password = u''
c.ServerApp.token = ''
c.ServerApp.allow_origin = '*'
c.ServerApp.disable_check_xsrf = True
c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash']}
EOF

# 设置 code-server json 配置文件
mkdir -p /root/.local/share/code-server/User
mv /tmp/settings.json /root/.local/share/code-server/User/settings.json
