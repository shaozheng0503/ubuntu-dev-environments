# =============================================================================
# TensorFlow 2.19 开发环境 Dockerfile
# =============================================================================
# 功能说明：
# 1. 基于 NVIDIA CUDA 12.9 构建深度学习环境
# 2. 安装 Python 3.12 + Miniconda 环境
# 3. 配置 TensorFlow 2.19 + JupyterLab + VSCode Server
# 4. 设置 SSH 服务和进程管理
# 
# 基础镜像：nvidia/cuda:12.9.1-cudnn-devel-ubuntu22.04
# 目标用户：深度学习开发者和研究人员
# 构建时间：约 30-60 分钟（取决于网络速度）
# =============================================================================

# =============================================================================
# 基础镜像选择
# =============================================================================
FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu22.04
# 使用 NVIDIA 官方 CUDA 12.9 开发镜像
# 包含完整的 CUDA Toolkit 和 cuDNN 库
# 支持 GPU 加速计算，适合深度学习任务

# =============================================================================
# 系统包源配置
# =============================================================================
# 配置国内镜像源，提高下载速度
# 将 Ubuntu 官方源替换为阿里云镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# =============================================================================
# 基础工具安装
# =============================================================================
# 更新包列表并安装 wget 工具
# wget 用于下载 Miniconda 安装包
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# =============================================================================
# Miniconda 环境安装和配置
# =============================================================================
# 下载并安装 Miniconda3
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && echo "PATH=/opt/miniconda3/bin:\$PATH" >> /etc/profile \
    && /opt/miniconda3/bin/conda init bash \
    # 先接受默认频道的服务条款（必需步骤）
    && /opt/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && /opt/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r \
    # 配置清华镜像源（提高国内下载速度）
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ \
    && /opt/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ \
    && /opt/miniconda3/bin/conda config --set show_channel_urls yes

# =============================================================================
# pip 镜像源配置
# =============================================================================
# 配置 pip 使用清华镜像源，提高 Python 包下载速度
RUN mkdir -p /root/.pip \
    && printf "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple \ntrusted-host = pypi.tuna.tsinghua.edu.cn\n" > /root/.pip/pip.conf

# =============================================================================
# Python 环境升级
# =============================================================================
# 将 base 环境的 Python 升级为 3.12
# Python 3.12 是当前最新的稳定版本，性能更好
RUN /opt/miniconda3/bin/conda install -y python=3.12

# =============================================================================
# Node.js 环境安装
# =============================================================================
# 安装 Node.js 20.x 版本，用于 JupyterLab 插件构建
# 更新 NodeSource 源 URL，确保安装最新版本
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# JupyterLab 安装
# =============================================================================
# 安装 JupyterLab 4.4.4 版本
# JupyterLab 是现代化的 Jupyter 界面
RUN /opt/miniconda3/bin/pip install jupyterlab==4.4.4

# =============================================================================
# JupyterLab 后端依赖安装
# =============================================================================
# 安装 JupyterLab 的后端依赖包
RUN /opt/miniconda3/bin/pip install \
    jupyterlab-lsp \          # 语言服务器协议支持
    python-lsp-server[all] \  # Python 语言服务器
    ipympl \                  # Matplotlib 集成
    jupyterlab-katex \        # 数学公式渲染
    ipykernel                 # IPython 内核

# =============================================================================
# JupyterLab 前端插件安装
# =============================================================================
# 安装 JupyterLab 的前端插件
RUN /opt/miniconda3/bin/jupyter labextension install \
    @jupyterlab/toc \         # 目录导航插件
    @jupyterlab/htmlviewer    # HTML 查看器插件

# =============================================================================
# TensorFlow 2.19 安装
# =============================================================================
# 安装 TensorFlow 2.19 版本（适配 CUDA 11.8）
# TensorFlow 2.19 是当前最新的稳定版本
RUN /opt/miniconda3/bin/pip install tensorflow==2.19.*

# =============================================================================
# 配置文件复制
# =============================================================================
# 复制容器启动和运行所需的配置文件
COPY config/supervisord.conf /etc/supervisord.conf    # 进程管理配置
COPY init/init.sh /init/init.sh                       # 初始化脚本
COPY config/settings.json  /tmp/settings.json         # VSCode 配置
RUN chmod +x /init/init.sh                            # 设置脚本执行权限

# =============================================================================
# 环境变量设置
# =============================================================================
# 定义构建参数：SSH 密码，默认值为 123456
ARG SSH_PASSWORD=123456

# 设置环境变量
ENV SSH_PASSWORD=${SSH_PASSWORD} \
    PATH=/usr/local/cuda-11.8/bin:$PATH \                    # CUDA 工具路径
    LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH  # CUDA 库路径

# =============================================================================
# 端口暴露
# =============================================================================
# 暴露容器内部端口，供外部访问
EXPOSE 22      # SSH 服务端口
EXPOSE 62661   # VSCode Server 端口
EXPOSE 8888    # JupyterLab 端口

# =============================================================================
# 网络工具安装
# =============================================================================
# 安装网络诊断工具，便于调试网络问题
RUN apt-get update && \
    apt-get install -y \
        net-tools && \        # 网络工具包（包含 netstat、ifconfig 等）
    rm -rf /var/lib/apt/lists/*

# =============================================================================
# 系统服务工具安装
# =============================================================================
# 安装容器运行必需的系统工具和服务
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    screen \                  # 终端复用工具
    openssh-server \          # SSH 服务器
    supervisor \              # 进程管理工具
    gnupg2 && \               # GPG 加密工具
    mkdir -p /var/run/sshd && \   # SSH 运行时目录
    mkdir -p /init               # 初始化脚本目录

# =============================================================================
# VSCode Server 安装
# =============================================================================
# 安装 VSCode Server，提供在线代码编辑功能
RUN curl -fsSL https://code-server.dev/install.sh | sh

# =============================================================================
# 默认用户设置
# =============================================================================
# 设置默认 SSH 用户名为 gongji
ENV SSH_USER=gongji

# =============================================================================
# 容器启动命令
# =============================================================================
# 容器启动时执行的命令
# 执行初始化脚本，配置环境并启动所有服务
CMD ["/init/init.sh"] 