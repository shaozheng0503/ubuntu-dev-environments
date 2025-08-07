#!/bin/bash

# 开发机基础镜像构建脚本
# 用于构建ubuntu2204-py311基础镜像

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

# 检查Docker是否运行
check_docker() {
    log_info "检查Docker服务状态..."
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker服务未运行，请启动Docker服务"
        exit 1
    fi
    log_success "Docker服务运行正常"
}

# 清理旧镜像
cleanup_old_images() {
    log_info "清理旧的测试镜像..."
    docker rmi ubuntu2204-py311:latest 2>/dev/null || true
    docker rmi ubuntu2204-py311:test 2>/dev/null || true
    log_success "清理完成"
}

# 构建镜像
build_image() {
    log_info "开始构建ubuntu2204-py311镜像..."
    
    # 构建参数
    BUILD_ARGS=""
    
    # 构建镜像
    docker build \
        --build-arg SSH_PASSWORD=123456 \
        --build-arg SSH_USER=ubuntu \
        -t ubuntu2204-py311:latest \
        -f ubuntu2204-py311 \
        .
    
    if [ $? -eq 0 ]; then
        log_success "镜像构建成功"
    else
        log_error "镜像构建失败"
        exit 1
    fi
}

# 测试镜像
test_image() {
    log_info "开始测试镜像..."
    
    # 创建测试容器
    CONTAINER_ID=$(docker run -d \
        --name test-devbox-py311 \
        -p 2223:22 \
        -p 8889:8888 \
        -p 62662:62661 \
        ubuntu2204-py311:latest)
    
    log_info "测试容器已启动，容器ID: $CONTAINER_ID"
    
    # 等待服务启动
    log_info "等待服务启动..."
    sleep 30
    
    # 测试SSH连接
    log_info "测试SSH连接..."
    if timeout 10 ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -p 2223 root@localhost "echo 'SSH连接成功'"; then
        log_success "SSH连接测试通过"
    else
        log_warning "SSH连接测试失败"
    fi
    
    # 测试JupyterLab
    log_info "测试JupyterLab服务..."
    if curl -s http://localhost:8889 >/dev/null; then
        log_success "JupyterLab服务测试通过"
    else
        log_warning "JupyterLab服务测试失败"
    fi
    
    # 测试Code-Server
    log_info "测试Code-Server服务..."
    if curl -s http://localhost:62662 >/dev/null; then
        log_success "Code-Server服务测试通过"
    else
        log_warning "Code-Server服务测试失败"
    fi
    
    # 测试Python环境
    log_info "测试Python环境..."
    if docker exec $CONTAINER_ID /opt/miniconda3/bin/python --version; then
        log_success "Python环境测试通过"
    else
        log_warning "Python环境测试失败"
    fi
    
    # 测试conda环境
    log_info "测试conda环境..."
    if docker exec $CONTAINER_ID /opt/miniconda3/bin/conda info --envs; then
        log_success "conda环境测试通过"
    else
        log_warning "conda环境测试失败"
    fi
    
    # 测试Python 3.11版本
    log_info "测试Python 3.11版本..."
    if docker exec $CONTAINER_ID /opt/miniconda3/bin/python --version | grep "Python 3.11"; then
        log_success "Python 3.11版本测试通过"
    else
        log_warning "Python版本测试失败"
    fi
    
    # 测试CUDA环境
    log_info "测试CUDA环境..."
    if docker exec $CONTAINER_ID nvidia-smi 2>/dev/null; then
        log_success "CUDA环境测试通过"
    else
        log_warning "CUDA环境测试失败（可能没有GPU）"
    fi
    
    # 停止并删除测试容器
    log_info "清理测试容器..."
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
    
    log_success "镜像测试完成"
}

# 生成镜像清单
generate_manifest() {
    log_info "生成镜像清单..."
    
    cat > IMAGE_MANIFEST_PY311.md << EOF
# Ubuntu 22.04 Python 3.11 开发机镜像清单

## 基础信息
- 基础镜像: ubuntu:22.04
- Python版本: 3.11
- CUDA版本: 11.8
- 镜像标签: ubuntu2204-py311:latest

## 预装组件

### 系统组件
- Ubuntu 22.04 LTS
- CUDA Toolkit 11.8
- OpenSSH Server
- Supervisor
- Screen
- Node.js 20.x

### Python环境
- Miniconda3 (最新版本)
- Python 3.11 (conda环境)
- pip (清华源配置)
- conda (清华源配置)

### 开发工具
- JupyterLab 4.4.4
- Code-Server (VSCode Server)
- Python LSP Server
- JupyterLab插件:
  - TOC (目录)
  - KaTeX (数学公式)
  - Matplotlib
  - Debugger
  - LSP Extension

### 文档支持
- LaTeX (texlive-xetex)
- 中文字体支持

## 服务端口
- SSH: 22
- JupyterLab: 8888
- Code-Server: 62661

## 默认用户
- 用户名: ubuntu
- 密码: 123456
- Root密码: 123456

## 环境变量
- SSH_USER=ubuntu
- SSH_PASSWORD=123456
- CONDA_DEFAULT_ENV=python3.11

## 工作目录
- /workspace (JupyterLab默认目录)

## 构建时间
$(date)

## 构建命令
\`\`\`bash
docker build -t ubuntu2204-py311:latest -f ubuntu2204-py311 .
\`\`\`

## 运行命令
\`\`\`bash
docker run -d \\
  --name devbox-py311 \\
  -p 2223:22 \\
  -p 8889:8888 \\
  -p 62662:62661 \\
  ubuntu2204-py311:latest
\`\`\`

## 访问方式
- SSH: ssh -p 2223 ubuntu@localhost
- JupyterLab: http://localhost:8889
- Code-Server: http://localhost:62662
EOF

    log_success "镜像清单已生成: IMAGE_MANIFEST_PY311.md"
}

# 主函数
main() {
    log_info "开始构建Python 3.11开发机基础镜像..."
    
    # 检查Docker
    check_docker
    
    # 清理旧镜像
    cleanup_old_images
    
    # 构建镜像
    build_image
    
    # 测试镜像
    test_image
    
    # 生成清单
    generate_manifest
    
    log_success "Python 3.11镜像构建和测试完成！"
    log_info "镜像标签: ubuntu2204-py311:latest"
    log_info "可以使用以下命令运行容器:"
    echo "docker run -d --name devbox-py311 -p 2223:22 -p 8889:8888 -p 62662:62661 ubuntu2204-py311:latest"
}

# 执行主函数
main "$@" 