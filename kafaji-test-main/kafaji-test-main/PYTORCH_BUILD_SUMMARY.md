# PyTorch 2.7.1 + Python 3.12 构建总结

## 创建的文件

### 1. 主要 Dockerfile
- **`ubuntu2204-py312-pytorch`**: 主要的 Dockerfile，包含 Python 3.12 和 PyTorch 2.7.1

### 2. 构建脚本
- **`build_py312_pytorch.sh`**: Linux/macOS 构建脚本
- **`build_py312_pytorch.bat`**: Windows 构建脚本

### 3. 测试脚本
- **`test_py312_pytorch.py`**: Python 测试脚本，验证 PyTorch 安装
- **`test_py312_pytorch.sh`**: Linux/macOS 测试脚本
- **`test_py312_pytorch.bat`**: Windows 测试脚本

### 4. 配置文件
- **`config/settings.json`**: VSCode Server 配置文件
- **`config/supervisord.conf`**: 已更新为使用 base 环境

### 5. 文档
- **`README_PYTORCH.md`**: 详细的使用说明文档
- **`PYTORCH_BUILD_SUMMARY.md`**: 本总结文档

## 主要特性

### 软件版本
- **Python**: 3.12
- **PyTorch**: 2.7.1
- **TorchVision**: 0.22.1
- **TorchAudio**: 2.7.1
- **CUDA**: 11.8 (支持 CUDA 12.1)
- **JupyterLab**: 4.4.4
- **VSCode Server**: 最新版本

### 端口配置
- **SSH**: 22 → 2222
- **JupyterLab**: 8888 → 8888
- **VSCode Server**: 62661 → 62661

### 环境配置
- 使用 base conda 环境（Python 3.12）
- 清华源配置（pip 和 conda）
- CUDA 环境变量配置
- 自动激活 conda 环境

## 构建步骤

### Windows 环境
```bash
# 构建镜像
build_py312_pytorch.bat

# 测试镜像
test_py312_pytorch.bat
```

### Linux/macOS 环境
```bash
# 构建镜像
./build_py312_pytorch.sh

# 测试镜像
./test_py312_pytorch.sh
```

## 运行容器

```bash
docker run -d --name py312-pytorch \
  -p 2222:22 \
  -p 8888:8888 \
  -p 62661:62661 \
  -v /path/to/workspace:/workspace \
  --gpus all \
  ubuntu2204-py312-pytorch:latest
```

## 访问服务

- **JupyterLab**: http://localhost:8888
- **VSCode Server**: http://localhost:62661
- **SSH**: `ssh root@localhost -p 2222` (密码: 123456)

## 验证安装

在容器内运行测试脚本：
```bash
python test_py312_pytorch.py
```

或在 JupyterLab 中测试：
```python
import torch
import torchvision
import torchaudio

print(f"PyTorch: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")

if torch.cuda.is_available():
    x = torch.randn(3, 3).cuda()
    print(f"GPU tensor: {x}")
```

## 与原始 Dockerfile 的主要区别

1. **Python 环境**: 使用 base 环境而不是 python3.12 环境
2. **PyTorch 版本**: 升级到 2.7.1 (最新稳定版)
3. **CUDA 支持**: 使用 CUDA 12.1 兼容的 PyTorch
4. **配置文件**: 添加了 VSCode Server 的 settings.json
5. **端口配置**: 确保所有端口映射正确

## 注意事项

1. 确保系统已安装 NVIDIA Docker 运行时
2. 构建时间可能较长（约 30-60 分钟）
3. 镜像大小约 8-12GB
4. 首次启动需要等待服务初始化（约 1-2 分钟）

## 故障排除

### 常见问题
1. **GPU 不可用**: 检查 nvidia-docker2 安装
2. **端口被占用**: 修改主机端口映射
3. **构建失败**: 检查网络连接和磁盘空间
4. **服务启动失败**: 查看容器日志 `docker logs <container_name>` 