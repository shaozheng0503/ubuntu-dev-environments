#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 停止并删除现有容器
log_info "停止并删除现有容器..."
docker stop $(docker ps -q --filter ancestor=ubuntu2204-py312:latest) 2>/dev/null || true
docker rm $(docker ps -aq --filter ancestor=ubuntu2204-py312:latest) 2>/dev/null || true

# 删除现有镜像
log_info "删除现有镜像..."
docker rmi ubuntu2204-py312:latest 2>/dev/null || true

# 构建新镜像
log_info "构建新镜像（端口已更新为62661）..."
docker build --build-arg SSH_PASSWORD=123456 --build-arg SSH_USER=ubuntu -t ubuntu2204-py312:latest -f ubuntu2204-py312 .

if [ $? -eq 0 ]; then
    log_success "镜像构建成功！"
    
    # 显示新的端口配置
    log_info "新的端口配置："
    echo "  - SSH: 22"
    echo "  - JupyterLab: 8888"
    echo "  - Code-Server: 62661"
    
    # 显示运行命令
    log_info "使用以下命令运行容器："
    echo "docker run -d --name devbox -p 2222:22 -p 8888:8888 -p 62661:62661 ubuntu2204-py312:latest"
    
    # 显示访问URL
    log_info "访问地址："
    echo "  - JupyterLab: http://localhost:8888/lab"
    echo "  - Code-Server: http://localhost:62661"
    echo "  - SSH: ssh -p 2222 ubuntu@localhost (密码: 123456)"
    
else
    log_error "镜像构建失败！"
    exit 1
fi 