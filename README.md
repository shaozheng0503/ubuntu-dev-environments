# 🚀 Ubuntu 开发环境镜像集合

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![CUDA](https://img.shields.io/badge/CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](https://developer.nvidia.com/cuda-zone)
[![PyTorch](https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=pytorch&logoColor=white)](https://pytorch.org/)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)](https://tensorflow.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> 🎯 **专为深度学习、科学计算和远程开发设计的完整开发环境集合**

## 📋 目录

- [✨ 项目概述](#-项目概述)
- [🏗️ 镜像架构](#️-镜像架构)
- [🚀 快速开始](#-快速开始)
- [🔧 环境配置](#-环境配置)
- [📦 镜像说明](#-镜像说明)
- [🧪 测试验证](#-测试验证)
- [🔗 SSH 连接工具](#-ssh-连接工具)
- [📚 使用指南](#-使用指南)
- [🤝 贡献指南](#-贡献指南)
- [📄 许可证](#-许可证)

## ✨ 项目概述

本项目提供了一套完整的 Ubuntu 开发环境镜像集合，涵盖了从基础开发环境到专业深度学习框架的多种配置。每个镜像都经过精心优化，确保在 Docker 容器中提供稳定、高效的开发体验。

### 🎯 核心特性

**多版本支持** - 支持 Ubuntu 20.04 和 22.04 两个主要版本，满足不同项目的兼容性需求。

**Python 环境** - 提供 Python 3.7 到 3.12 的完整版本支持，包括最新的稳定版本。

**深度学习框架** - 集成 PyTorch 2.5.1、2.7.1 和 TensorFlow 2.18、2.19 等主流深度学习框架。

**CUDA 支持** - 支持 CUDA 11.8 和 12.9，为 GPU 加速计算提供强大支持。

**开发工具集成** - 内置 JupyterLab、VSCode Server、SSH 服务等完整的开发工具链。

**进程管理** - 使用 Supervisord 进行多进程管理，确保服务稳定运行。

## 🏗️ 镜像架构

### 📁 目录结构

```
ubuntu/
├── 0722kafaji2204/          # PyTorch 2.5.1/2.7.1 专用镜像
├── 2004/                    # Ubuntu 20.04 基础镜像
├── 2204/                    # Ubuntu 22.04 基础镜像
├── 2204 - 0717/             # Ubuntu 22.04 定制版本
├── 2204-711/                # 主要开发镜像集合
├── kafaji-test-main/        # 测试版本镜像
├── pytroch2.51/             # PyTorch 2.5.1 专用镜像
├── sshlianjie/              # SSH 连接工具集
├── transflow2.18/           # TensorFlow 2.18 专用镜像
└── transflow2.19/           # TensorFlow 2.19 专用镜像
```

### 🔧 技术栈

**基础环境** - Ubuntu 20.04/22.04 + Docker + Supervisord

**Python 生态** - Miniconda + pip + 清华镜像源

**开发工具** - JupyterLab 4.4.4 + VSCode Server + SSH

**深度学习** - CUDA 11.8/12.9 + PyTorch + TensorFlow

**进程管理** - Supervisord 多进程容器管理

## 🚀 快速开始

### 1. 环境准备

确保您的系统已安装 Docker：

```bash
# 检查 Docker 版本
docker --version

# 启动 Docker 服务
sudo systemctl start docker
```

### 2. 构建镜像

选择适合您需求的镜像进行构建：

```bash
# 构建 Python 3.12 基础镜像
docker build -f 2204-711/ubuntu2204-py312 -t ubuntu2204-py312:latest .

# 构建 PyTorch 专用镜像
docker build -f 0722kafaji2204/pt251 -t pytorch251:latest .

# 构建 TensorFlow 专用镜像
docker build -f transflow2.18/TF2.18-py3.12 -t tensorflow218:latest .
```

### 3. 运行容器

```bash
# 启动开发环境
docker run -d \
  --name devbox \
  --gpus all \
  -p 2222:22 \
  -p 8888:8888 \
  -p 62661:62661 \
  ubuntu2204-py312:latest
```

### 4. 访问服务

| 服务 | 地址 | 说明 |
|------|------|------|
| **SSH** | `ssh -p 2222 ubuntu@localhost` | 用户名: `ubuntu`, 密码: `123456` |
| **JupyterLab** | http://localhost:8888/lab | 无密码访问 |
| **VSCode** | http://localhost:62661 | 无密码访问 |

## 🔧 环境配置

### 环境变量

```bash
# SSH 配置
SSH_USER=ubuntu
SSH_PASSWORD=123456

# 服务端口
SSH_PORT=22
JUPYTER_PORT=8888
VSCODE_PORT=62661

# Python 环境
CONDA_DEFAULT_ENV=python3.12
PYTHON_VERSION=3.12

# CUDA 环境
CUDA_VERSION=11.8
LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
```

### 自定义构建

```bash
# 自定义 SSH 用户和密码
docker build \
  --build-arg SSH_USER=myuser \
  --build-arg SSH_PASSWORD=mypassword \
  -f ubuntu2204-py312 \
  -t my-devbox:latest .

# 指定 CUDA 版本
docker build \
  --build-arg CUDA_VERSION=12.9 \
  -f pt251 \
  -t pytorch-cuda129:latest .
```

## 📦 镜像说明

### 🐍 Python 环境镜像

**ubuntu2204-py312** - Python 3.12 基础开发环境

基于 Ubuntu 22.04，集成 Python 3.12、JupyterLab、VSCode Server 和 SSH 服务。适合通用 Python 开发项目。

**ubuntu2204-py311** - Python 3.11 开发环境

提供 Python 3.11 的稳定开发环境，兼容性更好，适合生产环境部署。

**ubuntu2204-py310** - Python 3.10 开发环境

Python 3.10 的成熟版本，适合需要长期稳定性的项目。

### 🔥 PyTorch 专用镜像

**pt251** - PyTorch 2.5.1 + CUDA 12.9

最新的 PyTorch 2.5.1 版本，支持 CUDA 12.9，适合最新的深度学习研究和开发。

**pt271** - PyTorch 2.7.1 + CUDA 12.9

PyTorch 2.7.1 版本，提供更稳定的深度学习开发环境。

### 🧠 TensorFlow 专用镜像

**TF2.18-py3.12** - TensorFlow 2.18 + Python 3.12

TensorFlow 2.18 版本，支持最新的机器学习功能，适合大规模模型训练。

**TF219** - TensorFlow 2.19 + Python 3.12

TensorFlow 2.19 版本，提供最新的 TensorFlow 功能和优化。

### 🛠️ 基础工具镜像

**2004** - Ubuntu 20.04 基础镜像

基于 Ubuntu 20.04 的基础开发环境，适合需要长期稳定性的项目。

**2204** - Ubuntu 22.04 基础镜像

基于 Ubuntu 22.04 的现代化开发环境，提供最新的系统特性和安全更新。

## 🧪 测试验证

### 自动化测试

```bash
# 运行完整测试套件
python 2204-711/comprehensive_test.py

# 运行快速测试
python 2204-711/simple_test.py

# 运行 Supervisord 专项测试
python 2204-711/supervisord_detailed_test.py

# 测试 CUDA 功能
python 2204-711/test_cuda.py
```

### 手动验证

```bash
# 检查容器状态
docker ps

# 查看服务日志
docker logs devbox

# 进入容器
docker exec -it devbox bash

# 检查服务状态
docker exec devbox supervisorctl status

# 验证 CUDA 安装
docker exec devbox nvidia-smi
```

### 测试报告

测试完成后会生成详细的测试报告：
- `COMPREHENSIVE_TEST_REPORT.md` - 完整测试报告
- `SIMPLE_TEST_REPORT.md` - 快速测试报告
- `SUPERVISORD_DETAILED_TEST_REPORT.md` - Supervisord 专项报告

## 🔗 SSH 连接工具

### 服务器连接

项目提供了完整的 SSH 连接工具集，支持多服务器管理和多种连接方式：

```bash
# Windows 用户
sshlianjie/ssh_connect.bat
sshlianjie/quick_connect.bat 1

# Linux/macOS 用户
chmod +x sshlianjie/ssh_connect.sh
./sshlianjie/ssh_connect.sh

# PowerShell 用户
./sshlianjie/ssh_connect.ps1
```

### 服务器配置

| 服务器 | IP 地址 | 用户名 | 密码 | 端口 |
|--------|----------|--------|------|------|
| 服务器 1 | 43.135.68.39 | root | 8pA!5DRAq# | 22 |
| 服务器 2 | 43.132.192.253 | root | 8pA!5DRAq# | 22 |

## 📚 使用指南

### 容器管理

```bash
# 启动容器
docker run -d --name devbox \
  --gpus all \
  -p 2222:22 -p 8888:8888 -p 62661:62661 \
  ubuntu2204-py312:latest

# 停止容器
docker stop devbox

# 重启容器
docker restart devbox

# 删除容器
docker rm devbox

# 查看容器日志
docker logs -f devbox
```

### 服务管理

```bash
# 查看服务状态
docker exec devbox supervisorctl status

# 重启 SSH 服务
docker exec devbox supervisorctl restart sshd

# 重启 JupyterLab 服务
docker exec devbox supervisorctl restart jupyterlab

# 重启 VSCode 服务
docker exec devbox supervisorctl restart code-server

# 查看服务日志
docker exec devbox supervisorctl tail -f sshd
```

### 环境管理

```bash
# 激活 Python 环境
conda activate python3.12

# 安装 Python 包
pip install package_name

# 安装 Conda 包
conda install package_name

# 查看已安装的包
conda list

# 创建新环境
conda create -n myenv python=3.11

# 导出环境配置
conda env export > environment.yml
```

### 深度学习开发

```bash
# 验证 PyTorch 安装
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"

# 验证 TensorFlow 安装
python -c "import tensorflow as tf; print(tf.__version__); print(tf.config.list_physical_devices('GPU'))"

# 运行 GPU 测试
python test_cuda.py

# 启动 JupyterLab
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

## 🤝 贡献指南

我们欢迎所有形式的贡献！

### 开发环境设置

1. **Fork 项目**
2. **创建特性分支** (`git checkout -b feature/AmazingFeature`)
3. **提交更改** (`git commit -m 'Add some AmazingFeature'`)
4. **推送到分支** (`git push origin feature/AmazingFeature`)
5. **创建 Pull Request**

### 代码规范

- 遵循 PEP 8 Python 代码规范
- 添加适当的注释和文档
- 确保所有测试通过
- 更新相关文档

### 问题反馈

如果您发现了问题或有改进建议，请：
1. 查看 [Issues](https://github.com/shaozheng0503/kafaji-test/issues)
2. 创建新的 Issue 并详细描述问题
3. 提供复现步骤和环境信息

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢以下开源项目的支持：
- [Docker](https://www.docker.com/) - 容器化平台
- [Jupyter](https://jupyter.org/) - 交互式计算环境
- [VSCode](https://code.visualstudio.com/) - 代码编辑器
- [Conda](https://docs.conda.io/) - 包管理工具
- [Supervisord](http://supervisord.org/) - 进程管理工具
- [PyTorch](https://pytorch.org/) - 深度学习框架
- [TensorFlow](https://tensorflow.org/) - 机器学习框架

---

<div align="center">

**如果这个项目对您有帮助，请给它一个 ⭐️**

[![GitHub stars](https://img.shields.io/github/stars/shaozheng0503/kafaji-test.svg?style=social&label=Star)](https://github.com/shaozheng0503/kafaji-test)
[![GitHub forks](https://img.shields.io/github/forks/shaozheng0503/kafaji-test.svg?style=social&label=Fork)](https://github.com/shaozheng0503/kafaji-test)

</div> 