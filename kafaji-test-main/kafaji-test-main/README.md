# 🚀 Ubuntu 22.04 Python 3.12 开发机镜像

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![CUDA](https://img.shields.io/badge/CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](https://developer.nvidia.com/cuda-zone)
[![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> 🎯 **专为深度学习、科学计算和远程开发设计的完整开发环境**

## 📋 目录

- [✨ 特性](#-特性)
- [🚀 快速开始](#-快速开始)
- [🔧 环境配置](#-环境配置)
- [📦 包含组件](#-包含组件)
- [🧪 测试验证](#-测试验证)
- [📚 API 文档](#-api-文档)
- [🤝 贡献指南](#-贡献指南)
- [📄 许可证](#-许可证)

## ✨ 特性

### 🎯 核心功能
- **🔐 SSH 远程访问** - 支持密码和密钥认证
- **📊 JupyterLab 4.4.4** - 完整的交互式开发环境
- **💻 VSCode Server** - 在线代码编辑器
- **🐍 Python 3.12** - 最新稳定版本
- **⚡ CUDA 11.8** - GPU 加速支持
- **📦 Conda 环境管理** - 灵活的包管理

### 🛠️ 开发工具
- **🔍 LSP 支持** - 智能代码补全和错误检查
- **📝 LaTeX 支持** - 数学公式和文档编写
- **📈 Matplotlib** - 数据可视化
- **🎨 主题扩展** - 多种界面主题
- **🔧 调试工具** - 完整的调试环境

### 🏗️ 架构设计
- **🔄 Supervisord** - 多进程容器管理
- **🌐 服务网格就绪** - 支持 Istio 集成
- **📡 内网穿透兼容** - 支持远程访问
- **🔒 安全配置** - 生产环境就绪

## 🚀 快速开始

### 1. 构建镜像

```bash
# 克隆仓库
git clone https://github.com/shaozheng0503/kafaji-test.git
cd kafaji-test

# 构建基础镜像
docker build -f ubuntu2204-py312 -t ubuntu2204-py312:latest .
```

### 2. 运行容器

```bash
# 启动开发环境
docker run -d \
  --name devbox \
  -p 2222:22 \
  -p 8888:8888 \
  -p 62661:62661 \
  ubuntu2204-py312:latest
```

### 3. 访问服务

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
```

### 自定义构建

```bash
# 自定义 SSH 用户和密码
docker build \
  --build-arg SSH_USER=myuser \
  --build-arg SSH_PASSWORD=mypassword \
  -f ubuntu2204-py312 \
  -t my-devbox:latest .
```

## 📦 包含组件

### 🐍 Python 环境
- **Python 3.12.11** - 最新稳定版本
- **Miniconda** - 轻量级包管理器
- **清华源配置** - 国内高速下载
- **虚拟环境** - 隔离的开发环境

### 🔧 开发工具
- **JupyterLab 4.4.4** - 交互式开发环境
- **VSCode Server** - 在线代码编辑器
- **Node.js 20.x** - 前端工具支持
- **LaTeX** - 文档编写支持

### 🚀 深度学习支持
- **CUDA 11.8** - GPU 计算支持
- **cuDNN** - 深度学习加速库
- **PyTorch 支持** - 深度学习框架
- **TensorFlow 支持** - 机器学习框架

### 🔌 扩展插件
- **JupyterLab LSP** - 语言服务器协议
- **JupyterLab TOC** - 目录导航
- **JupyterLab LaTeX** - 数学公式支持
- **VSCode Python** - Python 开发支持
- **VSCode Jupyter** - Jupyter 集成

## 🧪 测试验证

### 自动化测试

```bash
# 运行完整测试套件
python comprehensive_test.py

# 运行快速测试
python simple_test.py

# 运行 Supervisord 专项测试
python supervisord_detailed_test.py
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
```

### 测试报告

测试完成后会生成详细的测试报告：
- `COMPREHENSIVE_TEST_REPORT.md` - 完整测试报告
- `SIMPLE_TEST_REPORT.md` - 快速测试报告
- `SUPERVISORD_DETAILED_TEST_REPORT.md` - Supervisord 专项报告

## 📚 API 文档

### 容器管理

```bash
# 启动容器
docker run -d --name devbox \
  -p 2222:22 -p 8888:8888 -p 62661:62661 \
  ubuntu2204-py312:latest

# 停止容器
docker stop devbox

# 重启容器
docker restart devbox

# 删除容器
docker rm devbox
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

---

<div align="center">

**如果这个项目对您有帮助，请给它一个 ⭐️**

[![GitHub stars](https://img.shields.io/github/stars/shaozheng0503/kafaji-test.svg?style=social&label=Star)](https://github.com/shaozheng0503/kafaji-test)
[![GitHub forks](https://img.shields.io/github/forks/shaozheng0503/kafaji-test.svg?style=social&label=Fork)](https://github.com/shaozheng0503/kafaji-test)

</div> 