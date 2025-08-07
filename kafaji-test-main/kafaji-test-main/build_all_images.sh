#!/bin/bash

# 开发机镜像构建脚本
# 支持构建不同版本的PyTorch和TensorFlow镜像

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# PyTorch版本列表
PYTORCH_VERSIONS=(
    "2.7.1"
    "2.6.0"
    "2.5.1"
    "2.4.1"
    "2.3.1"
    "2.2.2"
    "2.1.2"
    "2.0.1"
)

# TensorFlow版本列表
TENSORFLOW_VERSIONS=(
    "2.19.0"
    "2.18.0"
    "2.15.0"
    "2.11.0"
    "2.7.0"
    "2.4.0"
)

# 构建基础镜像
build_base_image() {
    log_info "构建基础镜像 ubuntu2204-py312..."
    docker build --build-arg SSH_PASSWORD=123456 --build-arg SSH_USER=ubuntu -t ubuntu2204-py312:latest -f ubuntu2204-py312 .
    log_success "基础镜像构建完成"
}

# 构建PyTorch镜像
build_pytorch_images() {
    log_info "开始构建PyTorch镜像..."
    
    for version in "${PYTORCH_VERSIONS[@]}"; do
        log_info "构建PyTorch ${version} 镜像..."
        
        # 创建临时Dockerfile
        cat > Dockerfile.pytorch.${version} << EOF
FROM ubuntu2204-py312:latest

# 设置环境变量
ENV CONDA_DEFAULT_ENV=python3.12
ENV PATH=/opt/miniconda3/envs/python3.12/bin:\$PATH

# 安装PyTorch ${version}
RUN /opt/miniconda3/bin/conda install -y -n python3.12 pytorch==${version} torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

# 安装常用的PyTorch相关包
RUN /opt/miniconda3/envs/python3.12/bin/pip install \\
    torchmetrics \\
    lightning \\
    transformers \\
    datasets \\
    accelerate \\
    wandb \\
    tensorboard

# 安装数据科学相关包
RUN /opt/miniconda3/envs/python3.12/bin/pip install \\
    numpy \\
    pandas \\
    matplotlib \\
    seaborn \\
    scikit-learn \\
    scipy \\
    jupyter \\
    ipywidgets

# 验证PyTorch安装
RUN /opt/miniconda3/envs/python3.12/bin/python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"

# 设置默认Python环境
RUN echo "conda activate python3.12" >> /root/.bashrc

# 暴露端口
EXPOSE 22 62661 8888

# 启动命令
CMD ["/init/init.sh"]
EOF
        
        # 构建镜像
        docker build -t ubuntu2204-py312-pytorch-${version}:latest -f Dockerfile.pytorch.${version} .
        
        # 清理临时文件
        rm Dockerfile.pytorch.${version}
        
        log_success "PyTorch ${version} 镜像构建完成"
    done
}

# 构建TensorFlow镜像
build_tensorflow_images() {
    log_info "开始构建TensorFlow镜像..."
    
    for version in "${TENSORFLOW_VERSIONS[@]}"; do
        log_info "构建TensorFlow ${version} 镜像..."
        
        # 创建临时Dockerfile
        cat > Dockerfile.tensorflow.${version} << EOF
FROM ubuntu2204-py312:latest

# 设置环境变量
ENV CONDA_DEFAULT_ENV=python3.12
ENV PATH=/opt/miniconda3/envs/python3.12/bin:\$PATH

# 安装TensorFlow ${version}
RUN /opt/miniconda3/envs/python3.12/bin/pip install tensorflow==${version}

# 安装TensorFlow相关包
RUN /opt/miniconda3/envs/python3.12/bin/pip install \\
    tensorflow-hub \\
    tensorflow-datasets \\
    tensorflow-addons \\
    keras \\
    keras-tuner

# 安装数据科学相关包
RUN /opt/miniconda3/envs/python3.12/bin/pip install \\
    numpy \\
    pandas \\
    matplotlib \\
    seaborn \\
    scikit-learn \\
    scipy \\
    jupyter \\
    ipywidgets

# 验证TensorFlow安装
RUN /opt/miniconda3/envs/python3.12/bin/python -c "import tensorflow as tf; print('TensorFlow version:', tf.__version__); print('GPU available:', len(tf.config.list_physical_devices('GPU')) > 0)"

# 设置默认Python环境
RUN echo "conda activate python3.12" >> /root/.bashrc

# 暴露端口
EXPOSE 22 62661 8888

# 启动命令
CMD ["/init/init.sh"]
EOF
        
        # 构建镜像
        docker build -t ubuntu2204-py312-tensorflow-${version}:latest -f Dockerfile.tensorflow.${version} .
        
        # 清理临时文件
        rm Dockerfile.tensorflow.${version}
        
        log_success "TensorFlow ${version} 镜像构建完成"
    done
}

# 生成镜像清单
generate_manifest() {
    log_info "生成镜像清单..."
    
    cat > IMAGE_MANIFEST.md << EOF
# 开发机镜像清单

## 基础镜像
- ubuntu2204-py312:latest - Ubuntu 22.04 + Python 3.12 + CUDA 11.8

## PyTorch镜像
$(for version in "${PYTORCH_VERSIONS[@]}"; do
    echo "- ubuntu2204-py312-pytorch-${version}:latest - PyTorch ${version}"
done)

## TensorFlow镜像
$(for version in "${TENSORFLOW_VERSIONS[@]}"; do
    echo "- ubuntu2204-py312-tensorflow-${version}:latest - TensorFlow ${version}"
done)

## 构建时间
$(date)

## 使用说明
\`\`\`bash
# 运行基础镜像
docker run -d --name devbox -p 2222:22 -p 8888:8888 -p 62661:62661 ubuntu2204-py312:latest

# 运行PyTorch镜像
docker run -d --name devbox-pytorch -p 2222:22 -p 8888:8888 -p 62661:62661 ubuntu2204-py312-pytorch-2.7.1:latest

# 运行TensorFlow镜像
docker run -d --name devbox-tensorflow -p 2222:22 -p 8888:8888 -p 62661:62661 ubuntu2204-py312-tensorflow-2.19.0:latest
\`\`\`

## 访问方式
- SSH: ssh -p 2222 root@localhost (密码: 123456)
- JupyterLab: http://localhost:8888
- Code-Server: http://localhost:62661

EOF

    log_success "镜像清单已生成: IMAGE_MANIFEST.md"
}

# 主函数
main() {
    log_info "开始构建开发机镜像..."
    
    # 构建基础镜像
    build_base_image
    
    # 构建PyTorch镜像
    build_pytorch_images
    
    # 构建TensorFlow镜像
    build_tensorflow_images
    
    # 生成镜像清单
    generate_manifest
    
    log_success "所有镜像构建完成！"
    log_info "镜像清单请查看: IMAGE_MANIFEST.md"
}

# 执行主函数
main "$@" 