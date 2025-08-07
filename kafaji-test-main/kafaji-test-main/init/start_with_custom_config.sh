#!/bin/bash

# 示例：动态配置 supervisord 并启动用户应用
# 使用方法：将此脚本内容复制到启动命令中

# 创建临时配置文件
cat > /etc/supervisord.conf << 'EOF'
[supervisord]
nodaemon=true
user=root
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid
childlogdir=/var/log/supervisor
loglevel=info

[unix_http_server]
file=/var/run/supervisor.sock
chmod=0700

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

# 基础服务
[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
autorestart=true
startsecs=5
startretries=3
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
stdout_logfile_maxbytes=0
stderr_logfile_maxbytes=0
user=root
priority=100

[program:jupyterlab]
command=/opt/miniconda3/bin/jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.password='' --ServerApp.allow_origin='*' --ServerApp.root_dir=/workspace
autostart=true
autorestart=true
startsecs=10
startretries=3
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
stdout_logfile_maxbytes=0
stderr_logfile_maxbytes=0
user=root
environment=PATH="/opt/miniconda3/bin:%(ENV_PATH)s",CONDA_DEFAULT_ENV="python3.11"
priority=200

[program:code-server]
command=/usr/bin/code-server --bind-addr=0.0.0.0:62661 --auth=none --user-data-dir=/root/.local/share/code-server --extensions-dir=/root/.local/share/code-server/extensions
autostart=true
autorestart=true
startsecs=10
startretries=3
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
stdout_logfile_maxbytes=0
stderr_logfile_maxbytes=0
user=root
priority=300

# 用户应用示例 - 请根据实际需求修改
[program:myapp]
command=/opt/miniconda3/bin/python /workspace/myapp.py
autostart=true
autorestart=true
startsecs=5
startretries=3
stdout_logfile=/tmp/myapp.log
stderr_logfile=/tmp/myapp_error.log
redirect_stderr=true
user=root
environment=PATH="/opt/miniconda3/bin:%(ENV_PATH)s",CONDA_DEFAULT_ENV="python3.11"
priority=400

[program:flask-app]
command=/opt/miniconda3/bin/python /workspace/flask_app.py
autostart=true
autorestart=true
startsecs=5
startretries=3
stdout_logfile=/tmp/flask.log
stderr_logfile=/tmp/flask_error.log
redirect_stderr=true
user=root
environment=PATH="/opt/miniconda3/bin:%(ENV_PATH)s",CONDA_DEFAULT_ENV="python3.11"
priority=500

[group:dev-services]
programs=sshd,jupyterlab,code-server
priority=999

[group:user-apps]
programs=myapp,flask-app
priority=1000
EOF

# 启动 supervisord
exec /usr/bin/supervisord -n -c /etc/supervisord.conf 