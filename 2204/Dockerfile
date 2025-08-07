FROM harbor.suanleme.cn/vm/base/ubuntu/ubuntu:22.04

# 替换为清华大学源
RUN echo > /etc/apt/sources.list && \   
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 安装常用工具
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    screen openssh-server supervisor  && \
    mkdir -p /var/run/sshd && \
    mkdir -p /init

# 允许root登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 创建 supervisord 配置文件
RUN mkdir -p /etc/supervisor/conf.d
COPY config/supervisor.conf /etc/supervisor/conf.d/supervisord.conf
COPY init/init.sh /init/init.sh

# 安装vscode server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 默认变量-用户名和密码
ENV SSH_USER=gongji
ENV SSH_PASSWORD=Zxcvbnm@123456

# 暴露 ssh 端口
EXPOSE 22

# 执行初始化脚本并启动服务
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/init/init.sh"]