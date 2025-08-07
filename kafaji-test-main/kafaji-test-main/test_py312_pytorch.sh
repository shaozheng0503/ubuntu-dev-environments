#!/bin/bash

# 测试 Python 3.12 + PyTorch 2.7.1 镜像

IMAGE_NAME="ubuntu2204-py312-pytorch"
CONTAINER_NAME="test-py312-pytorch"

echo "🧪 开始测试 $IMAGE_NAME 镜像..."

# 检查镜像是否存在
if ! docker images | grep -q "$IMAGE_NAME"; then
    echo "❌ 镜像 $IMAGE_NAME 不存在，请先构建镜像"
    exit 1
fi

# 停止并删除已存在的测试容器
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# 启动测试容器
echo "🚀 启动测试容器..."
docker run -d --name $CONTAINER_NAME \
    -p 2222:22 \
    -p 8888:8888 \
    -p 62661:62661 \
    --gpus all \
    $IMAGE_NAME:latest

# 等待容器启动
echo "⏳ 等待容器启动..."
sleep 10

# 测试 Python 版本
echo "🐍 测试 Python 版本..."
docker exec $CONTAINER_NAME python --version

# 测试 PyTorch 安装
echo "🔥 测试 PyTorch 安装..."
docker exec $CONTAINER_NAME python -c "
import torch
import torchvision
import torchaudio
print(f'PyTorch: {torch.__version__}')
print(f'TorchVision: {torchvision.__version__}')
print(f'TorchAudio: {torchaudio.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA version: {torch.version.cuda}')
    print(f'GPU count: {torch.cuda.device_count()}')
"

# 测试 CUDA 功能
echo "🎮 测试 CUDA 功能..."
docker exec $CONTAINER_NAME python -c "
import torch
if torch.cuda.is_available():
    x = torch.randn(3, 3).cuda()
    print(f'GPU tensor created successfully: {x.device}')
    y = x @ x.T
    print(f'Matrix multiplication on GPU: {y.shape}')
else:
    print('CUDA not available')
"

# 测试 JupyterLab
echo "📓 测试 JupyterLab..."
docker exec $CONTAINER_NAME jupyter lab --version

# 测试 VSCode Server
echo "💻 测试 VSCode Server..."
docker exec $CONTAINER_NAME code-server --version

# 测试服务状态
echo "🔍 检查服务状态..."
docker exec $CONTAINER_NAME supervisorctl status

# 测试端口连接
echo "🌐 测试端口连接..."
if curl -s http://localhost:8888 > /dev/null; then
    echo "✅ JupyterLab (8888) 可访问"
else
    echo "❌ JupyterLab (8888) 不可访问"
fi

if curl -s http://localhost:62661 > /dev/null; then
    echo "✅ VSCode Server (62661) 可访问"
else
    echo "❌ VSCode Server (62661) 不可访问"
fi

# 清理测试容器
echo "🧹 清理测试容器..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

echo "✅ 测试完成！"
echo ""
echo "访问地址:"
echo "- JupyterLab: http://localhost:8888"
echo "- VSCode Server: http://localhost:62661"
echo "- SSH: ssh root@localhost -p 2222 (密码: 123456)" 