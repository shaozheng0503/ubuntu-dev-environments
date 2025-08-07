#!/bin/bash

# ubuntu2204-py311 镜像功能测试脚本
# 用于验证镜像是否符合开发机需求

echo "=== ubuntu2204-py311 镜像功能测试 ==="
echo "测试时间: $(date)"
echo ""

# 1. 检查基础环境
echo "1. 检查基础环境..."
echo "Ubuntu 版本: $(lsb_release -d | cut -f2)"
echo "CUDA 版本: $(nvcc --version 2>/dev/null | grep "release" | cut -d' ' -f6 || echo "CUDA 未安装")"
echo "Python 版本: $(python3 --version)"
echo ""

# 2. 检查 Miniconda 环境
echo "2. 检查 Miniconda 环境..."
if [ -f "/opt/miniconda3/bin/conda" ]; then
    echo "Miniconda 已安装: $(/opt/miniconda3/bin/conda --version)"
    echo "当前 conda 环境: $CONDA_DEFAULT_ENV"
    echo "Python 路径: $(which python)"
    echo "pip 路径: $(which pip)"
else
    echo "❌ Miniconda 未安装"
fi
echo ""

# 3. 检查开发工具
echo "3. 检查开发工具..."
echo "VSCode Server: $(code-server --version 2>/dev/null || echo "未安装")"
echo "JupyterLab: $(jupyter lab --version 2>/dev/null || echo "未安装")"
echo "Node.js: $(node --version 2>/dev/null || echo "未安装")"
echo ""

# 4. 检查服务状态
echo "4. 检查服务状态..."
echo "SSH 服务: $(systemctl is-active ssh 2>/dev/null || echo "未运行")"
echo "Supervisord: $(supervisorctl status 2>/dev/null || echo "未运行")"
echo ""

# 5. 检查端口监听
echo "5. 检查端口监听..."
echo "端口 22 (SSH): $(netstat -tlnp 2>/dev/null | grep :22 || echo "未监听")"
echo "端口 8888 (JupyterLab): $(netstat -tlnp 2>/dev/null | grep :8888 || echo "未监听")"
echo "端口 62661 (VSCode Server): $(netstat -tlnp 2>/dev/null | grep :62661 || echo "未监听")"
echo ""

# 6. 检查 Python 包
echo "6. 检查 Python 包..."
echo "已安装的包:"
pip list | head -10
echo ""

# 7. 检查 JupyterLab 插件
echo "7. 检查 JupyterLab 插件..."
if command -v jupyter >/dev/null 2>&1; then
    echo "已安装的 JupyterLab 插件:"
    jupyter labextension list 2>/dev/null | head -10
else
    echo "JupyterLab 未安装"
fi
echo ""

# 8. 检查 VSCode 插件
echo "8. 检查 VSCode 插件..."
if [ -d "/root/.local/share/code-server/extensions" ]; then
    echo "已安装的 VSCode 插件:"
    ls /root/.local/share/code-server/extensions/ | head -10
else
    echo "VSCode 插件目录不存在"
fi
echo ""

# 9. 检查环境变量
echo "9. 检查环境变量..."
echo "PATH: $PATH"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "CONDA_DEFAULT_ENV: $CONDA_DEFAULT_ENV"
echo ""

# 10. 检查工作目录
echo "10. 检查工作目录..."
echo "当前工作目录: $(pwd)"
echo "workspace 目录: $(ls -la /workspace 2>/dev/null || echo "不存在")"
echo ""

echo "=== 测试完成 ===" 