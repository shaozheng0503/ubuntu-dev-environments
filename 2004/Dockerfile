FROM harbor1.suanleme.cn/vm/base/ubuntu/cuda:11.8.0-base-ubuntu20.04

# 设置清华源并安装基础工具
RUN truncate -s 0 /etc/apt/sources.list && \
    printf "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse\n" > /etc/apt/sources.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        screen openssh-server supervisor curl wget jq && \
    mkdir -p /var/run/sshd /init /etc/supervisor/conf.d && \
    rm -rf /var/lib/apt/lists/*

# 安装完整 CUDA Toolkit（含 nvcc）
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
    cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt update && \
    apt install -y cuda-toolkit-11-8 && \
    rm cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# 安装并配置 Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    echo "PATH=/opt/miniconda3/bin:\$PATH" >> /etc/profile && \
    /opt/miniconda3/bin/conda init bash && \
    /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/ && \
    /opt/miniconda3/bin/conda config --set show_channel_urls yes

# 配置 pip 清华源
RUN mkdir -p ~/.pip && \
    printf "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple\ntrusted-host = pypi.tuna.tsinghua.edu.cn\n" > ~/.pip/pip.conf

# 安装 code-server 并配置 SSH
RUN bash -c "source ~/.bashrc && curl -fsSL https://code-server.dev/install.sh | sh" 

# 安装常用 code-server 插件
RUN code-server --install-extension ms-python.python \
    && code-server --install-extension ms-pyright.pyright \
    && code-server --install-extension ms-toolsai.jupyter \
    && code-server --install-extension ms-python.debugpy

# 安装 Node.js（JupyterLab 插件构建用）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs

# 安装 JupyterLab 4.4.4 到 base 环境
RUN /opt/miniconda3/bin/conda install -y jupyterlab=4.4.4
# 安装 pip 依赖（后端）
RUN /opt/miniconda3/bin/pip install \
    jupyterlab-lsp \
    python-lsp-server[all] \
    ipympl \
    jupyterlab-katex \
    ipykernel

# 安装 JupyterLab 插件（前端）
RUN /opt/miniconda3/bin/jupyter labextension install \
    @jupyterlab/toc \
    @jupyterlab/htmlviewer

# 安装 LaTeX 支持（可选）
RUN apt install -y texlive-xetex texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra


# 复制配置文件
COPY config/supervisord.conf /etc/supervisord.conf
COPY init/init.sh /init/init.sh

# 设置环境变量
ARG SSH_PASSWORD=123456
ENV SSH_PASSWORD=${SSH_PASSWORD} \
    CODE_SERVER_PASSWORD=${SSH_PASSWORD} \
    JUPYTER_PASSWORD=${SSH_PASSWORD} \
    PATH=/usr/local/cuda-11.8/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH

# 暴露端口
EXPOSE 22 8080 8888

# 启动命令
CMD ["/init/init.sh"]
