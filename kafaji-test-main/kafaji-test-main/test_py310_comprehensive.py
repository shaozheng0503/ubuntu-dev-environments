#!/usr/bin/env python3
"""
ubuntu2204-py310 镜像综合测试脚本
用于验证开发机镜像的完整功能
"""

import os
import sys
import subprocess
import platform
import json
from pathlib import Path

def run_command(cmd, capture_output=True):
    """运行命令并返回结果"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=capture_output, text=True)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def test_basic_environment():
    """测试基础环境"""
    print("=== 1. 基础环境测试 ===")
    
    # 检查 Python 版本
    success, output, error = run_command("python --version")
    if success:
        print(f"✅ Python 版本: {output.strip()}")
    else:
        print(f"❌ Python 版本检查失败: {error}")
    
    # 检查 pip
    success, output, error = run_command("pip --version")
    if success:
        print(f"✅ pip 版本: {output.strip()}")
    else:
        print(f"❌ pip 检查失败: {error}")
    
    # 检查 conda
    success, output, error = run_command("conda --version")
    if success:
        print(f"✅ conda 版本: {output.strip()}")
    else:
        print(f"❌ conda 检查失败: {error}")
    
    # 检查当前 conda 环境
    success, output, error = run_command("conda info --envs")
    if success:
        print("✅ conda 环境列表:")
        print(output)
    else:
        print(f"❌ conda 环境检查失败: {error}")

def test_cuda_environment():
    """测试 CUDA 环境"""
    print("\n=== 2. CUDA 环境测试 ===")
    
    # 检查 nvcc
    success, output, error = run_command("nvcc --version")
    if success:
        print(f"✅ CUDA 编译器: {output.split('release')[1].split(',')[0].strip()}")
    else:
        print(f"❌ CUDA 编译器检查失败: {error}")
    
    # 检查 CUDA 环境变量
    cuda_path = os.environ.get('CUDA_PATH', '')
    if cuda_path:
        print(f"✅ CUDA_PATH: {cuda_path}")
    else:
        print("❌ CUDA_PATH 未设置")
    
    # 检查 LD_LIBRARY_PATH
    ld_path = os.environ.get('LD_LIBRARY_PATH', '')
    if 'cuda' in ld_path.lower():
        print(f"✅ LD_LIBRARY_PATH 包含 CUDA: {ld_path}")
    else:
        print(f"❌ LD_LIBRARY_PATH 未包含 CUDA: {ld_path}")

def test_development_tools():
    """测试开发工具"""
    print("\n=== 3. 开发工具测试 ===")
    
    # 检查 JupyterLab
    success, output, error = run_command("jupyter lab --version")
    if success:
        print(f"✅ JupyterLab 版本: {output.strip()}")
    else:
        print(f"❌ JupyterLab 检查失败: {error}")
    
    # 检查 code-server
    success, output, error = run_command("code-server --version")
    if success:
        print(f"✅ code-server 版本: {output.strip()}")
    else:
        print(f"❌ code-server 检查失败: {error}")
    
    # 检查 Node.js
    success, output, error = run_command("node --version")
    if success:
        print(f"✅ Node.js 版本: {output.strip()}")
    else:
        print(f"❌ Node.js 检查失败: {error}")

def test_python_packages():
    """测试 Python 包"""
    print("\n=== 4. Python 包测试 ===")
    
    # 检查已安装的包
    success, output, error = run_command("pip list")
    if success:
        packages = output.strip().split('\n')[2:]  # 跳过标题行
        print(f"✅ 已安装 {len(packages)} 个 Python 包")
        
        # 检查关键包
        key_packages = ['jupyter', 'jupyterlab', 'ipykernel', 'numpy', 'pandas']
        for pkg in key_packages:
            if any(pkg in pkg_info for pkg_info in packages):
                print(f"✅ {pkg} 已安装")
            else:
                print(f"❌ {pkg} 未安装")
    else:
        print(f"❌ pip list 失败: {error}")

def test_jupyterlab_extensions():
    """测试 JupyterLab 扩展"""
    print("\n=== 5. JupyterLab 扩展测试 ===")
    
    success, output, error = run_command("jupyter labextension list")
    if success:
        extensions = output.strip().split('\n')
        print(f"✅ 已安装 {len(extensions)} 个 JupyterLab 扩展")
        
        # 检查关键扩展
        key_extensions = ['@jupyterlab/toc', '@jupyterlab/debugger', '@jupyterlab/lsp']
        for ext in key_extensions:
            if any(ext in ext_info for ext_info in extensions):
                print(f"✅ {ext} 已安装")
            else:
                print(f"❌ {ext} 未安装")
    else:
        print(f"❌ JupyterLab 扩展检查失败: {error}")

def test_vscode_extensions():
    """测试 VSCode 扩展"""
    print("\n=== 6. VSCode 扩展测试 ===")
    
    extensions_dir = "/root/.local/share/code-server/extensions"
    if os.path.exists(extensions_dir):
        extensions = os.listdir(extensions_dir)
        print(f"✅ 已安装 {len(extensions)} 个 VSCode 扩展")
        
        # 检查关键扩展
        key_extensions = ['ms-python.python', 'ms-toolsai.jupyter', 'ms-python.pylance']
        for ext in key_extensions:
            if any(ext in ext_name for ext_name in extensions):
                print(f"✅ {ext} 已安装")
            else:
                print(f"❌ {ext} 未安装")
    else:
        print(f"❌ VSCode 扩展目录不存在: {extensions_dir}")

def test_services():
    """测试服务状态"""
    print("\n=== 7. 服务状态测试 ===")
    
    # 检查 supervisord
    success, output, error = run_command("supervisorctl status")
    if success:
        print("✅ supervisord 服务状态:")
        print(output)
    else:
        print(f"❌ supervisord 检查失败: {error}")
    
    # 检查端口监听
    ports_to_check = [22, 8888, 62661]
    for port in ports_to_check:
        success, output, error = run_command(f"netstat -tlnp | grep :{port}")
        if success:
            print(f"✅ 端口 {port} 正在监听")
        else:
            print(f"❌ 端口 {port} 未监听")

def test_environment_variables():
    """测试环境变量"""
    print("\n=== 8. 环境变量测试 ===")
    
    # 检查关键环境变量
    key_vars = ['PATH', 'LD_LIBRARY_PATH', 'CONDA_DEFAULT_ENV']
    for var in key_vars:
        value = os.environ.get(var, '')
        if value:
            print(f"✅ {var}: {value}")
        else:
            print(f"❌ {var} 未设置")

def test_workspace():
    """测试工作目录"""
    print("\n=== 9. 工作目录测试 ===")
    
    workspace_dir = "/workspace"
    if os.path.exists(workspace_dir):
        print(f"✅ 工作目录存在: {workspace_dir}")
        
        # 检查权限
        stat = os.stat(workspace_dir)
        if stat.st_mode & 0o755 == 0o755:
            print("✅ 工作目录权限正确")
        else:
            print("❌ 工作目录权限不正确")
    else:
        print(f"❌ 工作目录不存在: {workspace_dir}")

def main():
    """主测试函数"""
    print("🚀 开始 ubuntu2204-py310 镜像综合测试")
    print("=" * 50)
    
    try:
        test_basic_environment()
        test_cuda_environment()
        test_development_tools()
        test_python_packages()
        test_jupyterlab_extensions()
        test_vscode_extensions()
        test_services()
        test_environment_variables()
        test_workspace()
        
        print("\n" + "=" * 50)
        print("✅ 所有测试完成！")
        
    except Exception as e:
        print(f"\n❌ 测试过程中出现错误: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 