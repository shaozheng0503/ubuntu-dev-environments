# Ubuntu 22.04 + Python 3.12 + PyTorch 2.7.1 开发环境

这是一个基于 Ubuntu 22.04 的 Docker 镜像，集成了 Python 3.12 和 PyTorch 2.7.1，专为深度学习开发而设计。

## 镜像特性

- **基础系统**: Ubuntu 22.04
- **Python**: 3.12
- **PyTorch**: 2.7.1 (CUDA 12.1 支持)
- **CUDA**: 11.8
- **JupyterLab**: 4.4.4
- **VSCode Server**: 最新版本
- **SSH**: 支持远程连接

## 构建镜像

### Windows 环境
```bash
# 使用批处理文件构建
build_py312_pytorch.bat
```

### Linux/macOS 环境
```bash
# 使用 shell 脚本构建
./build_py312_pytorch.sh
```

### 手动构建
```bash
docker build -f ubuntu2204-py312-pytorch -t ubuntu2204-py312-pytorch:latest .
```

## 运行容器

### 基本运行
```bash
docker run -d --name py312-pytorch \
  -p 2222:22 \
  -p 8888:8888 \
  -p 62661:62661 \
  --gpus all \
  ubuntu2204-py312-pytorch:latest
```

### 挂载工作目录
```bash
docker run -d --name py312-pytorch \
  -p 2222:22 \
  -p 8888:8888 \
  -p 62661:62661 \
  -v /path/to/your/workspace:/workspace \
  --gpus all \
  ubuntu2204-py312-pytorch:latest
```

## 访问服务

### SSH 连接
```bash
ssh root@localhost -p 2222
# 密码: 123456
```

### JupyterLab
- URL: http://localhost:8888
- 无需密码，直接访问

### VSCode Server
- URL: http://localhost:62661
- 无需认证，直接访问

## 环境验证

### 进入容器验证
```bash
# 进入容器
docker exec -it py312-pytorch bash

# 验证 Python 版本
python --version

# 验证 PyTorch
python -c "import torch; print(f'PyTorch {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}')"
```

### 运行测试脚本
```bash
# 在容器内运行测试
python test_py312_pytorch.py
```

## 端口说明

| 服务 | 容器端口 | 主机端口 | 说明 |
|------|----------|----------|------|
| SSH | 22 | 2222 | SSH 远程连接 |
| JupyterLab | 8888 | 8888 | Jupyter 开发环境 |
| VSCode Server | 62661 | 62661 | VSCode 在线编辑器 |

## 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| SSH_PASSWORD | 123456 | SSH 密码 |
| SSH_USER | ubuntu | SSH 用户名 |
| CODE_SERVER_PASSWORD | 123456 | VSCode Server 密码 |
| JUPYTER_PASSWORD | 123456 | Jupyter 密码 |

## 预装软件

### Python 包
- PyTorch 2.7.1
- TorchVision 0.22.1
- TorchAudio 2.7.1
- JupyterLab 4.4.4
- ipympl (交互式绘图)
- jupyterlab-lsp (语言服务器)
- python-lsp-server[all] (Python 语言支持)

### 系统工具
- CUDA Toolkit 11.8
- Node.js 20.x
- VSCode Server
- SSH Server
- Supervisor
- Screen

## 使用示例

### 1. 启动容器
```bash
docker run -d --name pytorch-dev \
  -p 2222:22 \
  -p 8888:8888 \
  -p 62661:62661 \
  -v $(pwd)/workspace:/workspace \
  --gpus all \
  ubuntu2204-py312-pytorch:latest
```

### 2. 访问 JupyterLab
打开浏览器访问 http://localhost:8888

### 3. 在 JupyterLab 中测试 PyTorch
```python
import torch
import torchvision
import torchaudio

print(f"PyTorch: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")

# 测试 GPU 张量
if torch.cuda.is_available():
    x = torch.randn(3, 3).cuda()
    print(f"GPU tensor: {x}")
```

### 4. SSH 连接
```bash
ssh root@localhost -p 2222
# 密码: 123456
```

## 故障排除

### 1. GPU 不可用
确保安装了 NVIDIA Docker 运行时：
```bash
# 安装 nvidia-docker2
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

### 2. 端口被占用
修改主机端口映射：
```bash
docker run -d --name py312-pytorch \
  -p 2223:22 \
  -p 8889:8888 \
  -p 62662:62661 \
  --gpus all \
  ubuntu2204-py312-pytorch:latest
```

### 3. 容器启动失败
检查日志：
```bash
docker logs py312-pytorch
```

## 更新日志

- **v1.0.0**: 初始版本
  - Python 3.12
  - PyTorch 2.7.1
  - CUDA 11.8 支持
  - JupyterLab 4.4.4
  - VSCode Server 集成 