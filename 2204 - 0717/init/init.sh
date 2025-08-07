#!/bin/bash
set -e

# 设置 root 密码
echo "root:${SSH_PASSWORD}" | chpasswd

# 生成 code-server 配置文件
CONFIG_DIR="/root/.config/code-server"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
mkdir -p "${CONFIG_DIR}"


echo "生成 code-server 配置文件..."
cat <<EOF > "${CONFIG_FILE}"
bind-addr: 0.0.0.0:62661
auth: password
password: "${CODE_SERVER_PASSWORD}"
cert: false
EOF


# ✅ 设置 Jupyter Server 密码（兼容 JupyterLab 4.x）
if [[ -n "$JUPYTER_PASSWORD" ]]; then
  mkdir -p /root/.jupyter
  HASH=$(/opt/miniconda3/bin/python -c "from jupyter_server.auth import passwd; print(passwd('${JUPYTER_PASSWORD}'))")
  cat <<EOF > /root/.jupyter/jupyter_server_config.py
c.ServerApp.password = u'$HASH'
c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash']}
c.ServerApp.allow_origin = '*'
c.ServerApp.disable_check_xsrf = True
EOF
fi

# 设置 code-server json 配置文件
mkdir -p /root/.local/share/code-server/User
mv /tmp/settings.json /root/.local/share/code-server/User/settings.json

rm -f /init/init.sh