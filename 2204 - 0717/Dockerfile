FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 先用官方源安装 ca-certificates，保证后续换源能用 HTTPS
RUN apt-get update && apt-get install -y ca-certificates

# 换成清华源
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list \
    && sed -i 's|http://security.ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list

# 1. 安装常用系统依赖（含编译工具、SSH、supervisor、Python3 基础工具等）
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    bash \
    apt-utils \
    ca-certificates \
    openssh-server \
    supervisor \
    sudo \
    locales \
    python3-pip \
    python3-setuptools \
    python3-dev \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# 2. 设置时区和中文 locale
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && locale-gen zh_CN.UTF-8 \
    && update-locale LANG=zh_CN.UTF-8

# 3. 安装并配置 Miniconda（仅安装，不激活 base 环境）
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && echo "PATH=/opt/miniconda3/bin:$PATH" >> /etc/profile \
    && /opt/miniconda3/bin/conda init bash \
    # 移除官方源，避免 ToS 问题，仅用清华源
    && /opt/miniconda3/bin/conda config --remove channels defaults || true \
    && /opt/miniconda3/bin/conda config --remove channels https://repo.anaconda.com/pkgs/main || true \
    && /opt/miniconda3/bin/conda config --remove channels https://repo.anaconda.com/pkgs/r || true \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/  \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/  \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/  \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/  \
    && /opt/miniconda3/bin/conda config --set show_channel_urls yes

# 4. 安装 CUDA Toolkit 11.8 及 cuDNN 8.9.7.29（系统级别安装，所有 conda 环境共享 GPU 能力）
#    这样 PyTorch、TensorFlow 等框架在任意 conda 环境下都能自动检测和调用 CUDA/cuDNN
RUN apt-get update && apt-get install -y wget gnupg2 && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin && \
    mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub && \
    apt-key add 3bf863cc.pub && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get update && \
    apt-get -y install cuda-toolkit-11-8

# 安装 cuDNN
RUN apt-get update && \
    apt-get install -y libcudnn8=8.9.7.29-1+cuda11.8 libcudnn8-dev=8.9.7.29-1+cuda11.8

# 5. 验证 CUDA 和 cuDNN 版本（可选，便于调试）
RUN nvcc --version && ldconfig && echo "cuDNN version:" && cat /usr/include/cudnn_version.h | grep CUDNN_MAJOR -A 2

# 6. 配置 pip 使用清华源
RUN mkdir -p ~/.pip \
    && printf "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple \ntrusted-host = pypi.tuna.tsinghua.edu.cn\n" > ~/.pip/pip.conf

# 7. 升级 base 环境 Python 到 3.12（conda 方式）
RUN /opt/miniconda3/bin/conda install -y python=3.12

# 8. 安装 Node.js（JupyterLab 插件构建用）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x  | bash - \
    && apt-get install -y nodejs

# 9. 安装 JupyterLab 到 base 环境
RUN /opt/miniconda3/bin/conda install -y jupyterlab=4.4.4

# 10. 安装 JupyterLab 相关后端依赖（pip 方式）
RUN /opt/miniconda3/bin/pip install \
    jupyterlab-lsp \
    python-lsp-server[all] \
    ipympl \
    jupyterlab-katex \
    ipykernel

# 11. 安装 JupyterLab 前端插件
RUN /opt/miniconda3/bin/jupyter labextension install \
    @jupyterlab/toc \
    @jupyterlab/htmlviewer

# 12. 安装 LaTeX 支持（可选）
RUN apt-get update && apt-get install -y \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-latex-recommended \
    texlive-latex-extra

# 13. 安装 PyTorch 2.7.1 及相关依赖（pip 方式，CUDA 12.1 版 whl，自动适配系统 CUDA）
RUN /opt/miniconda3/bin/pip install torch==2.7.1 torchvision==0.17.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu121

# 14. 复制 supervisord、初始化脚本、VSCode 配置
COPY config/supervisord.conf /etc/supervisord.conf
COPY init/init.sh /init/init.sh
COPY config/settings.json  /tmp/settings.json

# 15. 设置常用环境变量（含 CUDA 路径，确保所有 conda 环境都能用 nvcc/cuDNN）
ARG SSH_PASSWORD=123456
ENV SSH_PASSWORD=${SSH_PASSWORD} \
    CODE_SERVER_PASSWORD=${SSH_PASSWORD} \
    JUPYTER_PASSWORD=${SSH_PASSWORD} \
    PATH=/usr/local/cuda-11.8/bin:/opt/miniconda3/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64

# 16. 暴露常用端口（SSH、VSCode、JupyterLab）
EXPOSE 22 62661 8888

# 17. 容器启动时执行初始化脚本
CMD ["/init/init.sh"]