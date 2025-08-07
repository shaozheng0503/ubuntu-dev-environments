FROM harbor1.suanleme.cn/vm/base/ubuntu2004:cuda-11.8

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

# 安装python3.12
RUN /opt/miniconda3/bin/conda create -y -n python3.12 python=3.12 
# 更改.bashrc 默认启动python3.12
RUN echo "source /opt/miniconda3/etc/profile.d/conda.sh && conda activate python3.12" >> /root/.bashrc
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
COPY config/settings.json  /tmp/settings.json
# 设置环境变量
ARG SSH_PASSWORD=123456
ENV SSH_PASSWORD=${SSH_PASSWORD} \
    CODE_SERVER_PASSWORD=${SSH_PASSWORD} \
    JUPYTER_PASSWORD=${SSH_PASSWORD} \
    PATH=/usr/local/cuda-11.8/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH

# 暴露端口
EXPOSE 22 8081 8888

# 启动命令
CMD ["/init/init.sh"]