#!/bin/bash

# 开发机基础镜像测试脚本
# 用于验证ubuntu2204-py312镜像的各项功能

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

# 测试容器名称
CONTAINER_NAME="test-devbox-complete"

# 清理旧容器
cleanup() {
    log_info "清理旧容器..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
}

# 启动测试容器
start_container() {
    log_info "启动测试容器..."
    docker run -d \
        --name $CONTAINER_NAME \
        -p 2222:22 \
        -p 8888:8888 \
        -p 62661:62661 \
        ubuntu2204-py312:latest
    
    log_info "等待服务启动..."
    sleep 60
}

# 测试SSH服务
test_ssh() {
    log_info "测试SSH服务..."
    # 先检查端口是否开放
    if nc -z localhost 2222 2>/dev/null; then
        log_success "SSH端口2222开放"
        # 尝试SSH连接，使用更宽松的超时设置
        if timeout 30 ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -p 2222 root@localhost "echo 'SSH连接成功' && exit 0" 2>/dev/null; then
            log_success "SSH连接测试通过"
            return 0
        else
            log_warning "SSH连接测试失败，但端口已开放"
            return 1
        fi
    else
        log_warning "SSH端口2222未开放"
        return 1
    fi
}

# 测试JupyterLab服务
test_jupyterlab() {
    log_info "测试JupyterLab服务..."
    if curl -s http://localhost:8888 >/dev/null; then
        log_success "JupyterLab服务测试通过"
        return 0
    else
        log_warning "JupyterLab服务测试失败"
        return 1
    fi
}

# 测试Code-Server服务
test_codeserver() {
    log_info "测试Code-Server服务..."
    if curl -s http://localhost:62661 >/dev/null; then
        log_success "Code-Server服务测试通过"
        return 0
    else
        log_warning "Code-Server服务测试失败"
        return 1
    fi
}

# 测试Python环境
test_python() {
    log_info "测试Python环境..."
    if docker exec $CONTAINER_NAME /opt/miniconda3/bin/python --version; then
        log_success "Python环境测试通过"
        return 0
    else
        log_warning "Python环境测试失败"
        return 1
    fi
}

# 测试conda环境
test_conda() {
    log_info "测试conda环境..."
    if docker exec $CONTAINER_NAME /opt/miniconda3/bin/conda info --envs; then
        log_success "conda环境测试通过"
        return 0
    else
        log_warning "conda环境测试失败"
        return 1
    fi
}

# 测试CUDA环境
test_cuda() {
    log_info "测试CUDA环境..."
    if docker exec $CONTAINER_NAME /usr/local/cuda-11.8/bin/nvcc --version; then
        log_success "CUDA环境测试通过"
        return 0
    else
        log_warning "CUDA环境测试失败"
        return 1
    fi
}

# 测试supervisord服务
test_supervisord() {
    log_info "测试supervisord服务..."
    if docker exec $CONTAINER_NAME ps aux | grep supervisord; then
        log_success "supervisord服务测试通过"
        return 0
    else
        log_warning "supervisord服务测试失败"
        return 1
    fi
}

# 测试VSCode扩展
test_vscode_extensions() {
    log_info "测试VSCode扩展..."
    if docker exec $CONTAINER_NAME ls /root/.local/share/code-server/extensions; then
        log_success "VSCode扩展测试通过"
        return 0
    else
        log_warning "VSCode扩展测试失败"
        return 1
    fi
}

# 测试JupyterLab扩展
test_jupyterlab_extensions() {
    log_info "测试JupyterLab扩展..."
    if docker exec $CONTAINER_NAME /opt/miniconda3/bin/jupyter labextension list; then
        log_success "JupyterLab扩展测试通过"
        return 0
    else
        log_warning "JupyterLab扩展测试失败"
        return 1
    fi
}

# 生成测试报告
generate_report() {
    log_info "生成测试报告..."
    
    cat > TEST_REPORT.md << EOF
# Ubuntu 22.04 Python 3.12 开发机镜像测试报告

## 测试时间
$(date)

## 镜像信息
- 镜像名称: ubuntu2204-py312:latest
- 基础镜像: ubuntu:22.04
- Python版本: 3.12.11
- CUDA版本: 11.8

## 测试结果

### 基础服务测试
- SSH服务: $SSH_RESULT
- JupyterLab服务: $JUPYTER_RESULT
- Code-Server服务: $CODESERVER_RESULT
- supervisord服务: $SUPERVISORD_RESULT

### 开发环境测试
- Python环境: $PYTHON_RESULT
- conda环境: $CONDA_RESULT
- CUDA环境: $CUDA_RESULT

### 扩展功能测试
- VSCode扩展: $VSCODE_RESULT
- JupyterLab扩展: $JUPYTERLAB_RESULT

## 服务端口
- SSH: 2222
- JupyterLab: 8888
- Code-Server: 62661

## 访问方式
- SSH: ssh -p 2222 root@localhost (密码: 123456)
- JupyterLab: http://localhost:8888
- Code-Server: http://localhost:62661

## 环境变量
- SSH_USER=ubuntu
- SSH_PASSWORD=123456
- CONDA_DEFAULT_ENV=python3.12

## 工作目录
- /workspace (JupyterLab默认目录)

EOF

    log_success "测试报告已生成: TEST_REPORT.md"
}

# 主函数
main() {
    log_info "开始开发机基础镜像测试..."
    
    # 清理旧容器
    cleanup
    
    # 启动测试容器
    start_container
    
    # 执行各项测试
    test_ssh
    SSH_RESULT=$?
    
    test_jupyterlab
    JUPYTER_RESULT=$?
    
    test_codeserver
    CODESERVER_RESULT=$?
    
    test_supervisord
    SUPERVISORD_RESULT=$?
    
    test_python
    PYTHON_RESULT=$?
    
    test_conda
    CONDA_RESULT=$?
    
    test_cuda
    CUDA_RESULT=$?
    
    test_vscode_extensions
    VSCODE_RESULT=$?
    
    test_jupyterlab_extensions
    JUPYTERLAB_RESULT=$?
    
    # 生成测试报告
    generate_report
    
    # 清理测试容器
    log_info "清理测试容器..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    
    log_success "测试完成！"
    log_info "详细报告请查看: TEST_REPORT.md"
}

# 执行主函数
main "$@" 