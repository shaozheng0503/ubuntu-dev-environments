#!/bin/bash

# 构建 Python 3.12 + PyTorch 2.7.1 镜像
echo "开始构建 ubuntu2204-py312-pytorch 镜像..."

# 设置镜像名称和标签
IMAGE_NAME="ubuntu2204-py312-pytorch"
TAG="latest"

# 构建镜像
docker build -f ubuntu2204-py312-pytorch -t ${IMAGE_NAME}:${TAG} .

# 检查构建结果
if [ $? -eq 0 ]; then
    echo "✅ 镜像构建成功: ${IMAGE_NAME}:${TAG}"
    echo ""
    echo "镜像信息:"
    echo "- Python 3.12"
    echo "- PyTorch 2.7.1"
    echo "- CUDA 11.8"
    echo "- JupyterLab 4.4.4"
    echo "- VSCode Server"
    echo ""
    echo "端口映射:"
    echo "- SSH: 22"
    echo "- JupyterLab: 8888"
    echo "- VSCode Server: 62661"
    echo ""
    echo "运行命令示例:"
    echo "docker run -d --name py312-pytorch \\"
    echo "  -p 2222:22 \\"
    echo "  -p 8888:8888 \\"
    echo "  -p 62661:62661 \\"
    echo "  --gpus all \\"
    echo "  ${IMAGE_NAME}:${TAG}"
else
    echo "❌ 镜像构建失败"
    exit 1
fi 