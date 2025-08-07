#!/usr/bin/env python3
"""
Python 3.11 镜像全面测试脚本
测试内容：
1. Python 环境
2. CUDA 环境
3. 服务状态
4. 开发工具
5. 网络连接
"""

import subprocess
import time
import requests
import json

def run_command(cmd, timeout=30):
    """运行命令并返回结果"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=timeout)
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "命令超时"
    except Exception as e:
        return False, "", str(e)

def test_python_environment():
    """测试 Python 环境"""
    print("=== 测试 Python 环境 ===")
    
    # 测试 Python 3.11 版本
    success, stdout, stderr = run_command(
        'docker exec test-py311 /opt/miniconda3/envs/python3.11/bin/python --version'
    )
    if success:
        print(f"✓ Python 版本: {stdout.strip()}")
    else:
        print(f"✗ Python 版本测试失败: {stderr}")
    
    # 测试 conda 环境
    success, stdout, stderr = run_command(
        'docker exec test-py311 /opt/miniconda3/bin/conda info --envs'
    )
    if success:
        print(f"✓ Conda 环境列表:\n{stdout}")
    else:
        print(f"✗ Conda 环境测试失败: {stderr}")
    
    # 测试 pip 配置
    success, stdout, stderr = run_command(
        'docker exec test-py311 cat /root/.pip/pip.conf'
    )
    if success:
        print(f"✓ Pip 配置:\n{stdout}")
    else:
        print(f"✗ Pip 配置测试失败: {stderr}")

def test_cuda_environment():
    """测试 CUDA 环境"""
    print("\n=== 测试 CUDA 环境 ===")
    
    # 测试 CUDA 路径
    success, stdout, stderr = run_command(
        'docker exec test-py311 ls -la /usr/local/cuda-11.8/bin/'
    )
    if success:
        print("✓ CUDA 11.8 工具链已安装")
    else:
        print(f"✗ CUDA 工具链测试失败: {stderr}")
    
    # 测试环境变量
    success, stdout, stderr = run_command(
        'docker exec test-py311 bash -c "echo \$CUDA_HOME"'
    )
    if success and stdout.strip():
        print(f"✓ CUDA_HOME: {stdout.strip()}")
    else:
        print("✗ CUDA_HOME 未设置")

def test_services():
    """测试服务状态"""
    print("\n=== 测试服务状态 ===")
    
    # 测试进程
    success, stdout, stderr = run_command(
        'docker exec test-py311 ps aux'
    )
    if success:
        print("✓ 进程列表:")
        for line in stdout.split('\n'):
            if any(service in line for service in ['supervisord', 'sshd', 'jupyter', 'code-server']):
                print(f"  {line}")
    else:
        print(f"✗ 进程测试失败: {stderr}")
    
    # 测试端口
    success, stdout, stderr = run_command(
        'docker exec test-py311 netstat -tlnp'
    )
    if success:
        print("✓ 端口监听:")
        for line in stdout.split('\n'):
            if any(port in line for port in ['22', '8888', '62661']):
                print(f"  {line}")
    else:
        print(f"✗ 端口测试失败: {stderr}")

def test_development_tools():
    """测试开发工具"""
    print("\n=== 测试开发工具 ===")
    
    # 测试 JupyterLab
    success, stdout, stderr = run_command(
        'docker exec test-py311 /opt/miniconda3/bin/jupyter --version'
    )
    if success:
        print(f"✓ Jupyter 版本: {stdout.strip()}")
    else:
        print(f"✗ Jupyter 测试失败: {stderr}")
    
    # 测试 Code-Server
    success, stdout, stderr = run_command(
        'docker exec test-py311 /usr/bin/code-server --version'
    )
    if success:
        print(f"✓ Code-Server 版本: {stdout.strip()}")
    else:
        print(f"✗ Code-Server 测试失败: {stderr}")
    
    # 测试 Screen
    success, stdout, stderr = run_command(
        'docker exec test-py311 screen --version'
    )
    if success:
        print(f"✓ Screen 版本: {stdout.strip()}")
    else:
        print(f"✗ Screen 测试失败: {stderr}")

def test_network_services():
    """测试网络服务"""
    print("\n=== 测试网络服务 ===")
    
    # 测试 JupyterLab HTTP 服务
    try:
        response = requests.get('http://localhost:8889', timeout=5)
        if response.status_code == 200:
            print("✓ JupyterLab HTTP 服务正常")
        else:
            print(f"✗ JupyterLab HTTP 服务异常: {response.status_code}")
    except Exception as e:
        print(f"✗ JupyterLab HTTP 服务连接失败: {e}")
    
    # 测试 Code-Server HTTP 服务
    try:
        response = requests.get('http://localhost:62662', timeout=5)
        if response.status_code == 200:
            print("✓ Code-Server HTTP 服务正常")
        else:
            print(f"✗ Code-Server HTTP 服务异常: {response.status_code}")
    except Exception as e:
        print(f"✗ Code-Server HTTP 服务连接失败: {e}")

def test_python_packages():
    """测试 Python 包"""
    print("\n=== 测试 Python 包 ===")
    
    packages = [
        'jupyterlab',
        'jupyterlab-lsp',
        'python-lsp-server',
        'ipympl',
        'jupyterlab-katex',
        'ipykernel'
    ]
    
    for package in packages:
        success, stdout, stderr = run_command(
            f'docker exec test-py311 /opt/miniconda3/bin/pip show {package}'
        )
        if success:
            print(f"✓ {package} 已安装")
        else:
            print(f"✗ {package} 未安装或测试失败")

def test_conda_configuration():
    """测试 Conda 配置"""
    print("\n=== 测试 Conda 配置 ===")
    
    # 测试 conda 源配置
    success, stdout, stderr = run_command(
        'docker exec test-py311 /opt/miniconda3/bin/conda config --show channels'
    )
    if success:
        print("✓ Conda 源配置:")
        print(stdout)
    else:
        print(f"✗ Conda 源配置测试失败: {stderr}")

def main():
    """主测试函数"""
    print("开始全面测试 Python 3.11 镜像...")
    print("=" * 50)
    
    # 检查容器是否运行
    success, stdout, stderr = run_command('docker ps --filter name=test-py311')
    if not success or 'test-py311' not in stdout:
        print("✗ 测试容器未运行，请先启动容器")
        return
    
    print("✓ 测试容器正在运行")
    
    # 执行各项测试
    test_python_environment()
    test_cuda_environment()
    test_services()
    test_development_tools()
    test_network_services()
    test_python_packages()
    test_conda_configuration()
    
    print("\n" + "=" * 50)
    print("测试完成！")

if __name__ == "__main__":
    main() 