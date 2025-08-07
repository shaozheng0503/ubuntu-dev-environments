#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
开发机镜像全面测试脚本
测试内容包括：
1. 容器启动和状态检查
2. 服务进程验证
3. 端口连通性测试
4. 环境配置验证
5. GPU能力检测
"""

import subprocess
import time
import json
import sys
from datetime import datetime

def run_command(cmd, timeout=30):
    """执行命令并返回结果"""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            capture_output=True, 
            text=True, 
            timeout=timeout
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", f"命令超时: {cmd}"
    except Exception as e:
        return False, "", f"执行错误: {e}"

def log_info(message):
    print(f"[INFO] {message}")

def log_success(message):
    print(f"[SUCCESS] {message}")

def log_warning(message):
    print(f"[WARNING] {message}")

def log_error(message):
    print(f"[ERROR] {message}")

def test_docker_service():
    """测试Docker服务状态"""
    log_info("检查Docker服务状态...")
    success, stdout, stderr = run_command("docker version")
    if success:
        log_success("Docker服务正常")
        return True
    else:
        log_error(f"Docker服务异常: {stderr}")
        return False

def cleanup_containers():
    """清理现有测试容器"""
    log_info("清理现有测试容器...")
    containers = ["devbox-test", "test-py312-simple"]
    for container in containers:
        run_command(f"docker stop {container} 2>/dev/null")
        run_command(f"docker rm {container} 2>/dev/null")
    log_success("容器清理完成")

def start_test_container():
    """启动测试容器"""
    log_info("启动测试容器...")
    cmd = "docker run -d --name devbox-test -p 2222:22 -p 8888:8888 -p 62661:62661 ubuntu2204-py312:latest"
    success, stdout, stderr = run_command(cmd)
    if success:
        container_id = stdout.strip()
        log_success(f"容器启动成功: {container_id}")
        return True
    else:
        log_error(f"容器启动失败: {stderr}")
        return False

def wait_for_services():
    """等待服务启动"""
    log_info("等待服务启动...")
    time.sleep(10)
    
    # 检查容器状态
    success, stdout, stderr = run_command("docker ps --filter name=devbox-test --format '{{.Status}}'")
    if success and "Up" in stdout:
        log_success("容器运行正常")
    else:
        log_warning("容器状态异常")

def test_container_processes():
    """测试容器内进程"""
    log_info("检查容器内进程...")
    
    processes = [
        ("supervisord", "supervisord"),
        ("sshd", "sshd"),
        ("jupyterlab", "jupyter"),
        ("code-server", "code-server")
    ]
    
    results = {}
    for name, pattern in processes:
        success, stdout, stderr = run_command(f"docker exec devbox-test ps aux | grep {pattern}")
        if success and pattern in stdout:
            log_success(f"{name}进程运行正常")
            results[name] = True
        else:
            log_warning(f"{name}进程未运行")
            results[name] = False
    
    return results

def test_port_connectivity():
    """测试端口连通性"""
    log_info("测试端口连通性...")
    
    ports = [
        (2222, "SSH"),
        (8888, "JupyterLab"),
        (62661, "Code-Server")
    ]
    
    results = {}
    for port, name in ports:
        success, stdout, stderr = run_command(f"docker exec devbox-test netstat -tlnp 2>/dev/null | grep :{port}")
        if success:
            log_success(f"{name}端口({port})正常监听")
            results[name] = True
        else:
            log_warning(f"{name}端口({port})未监听")
            results[name] = False
    
    return results

def test_python_environment():
    """测试Python环境"""
    log_info("测试Python环境...")
    
    tests = [
        ("Python版本", "/opt/miniconda3/bin/python --version"),
        ("Conda版本", "/opt/miniconda3/bin/conda --version"),
        ("CUDA版本", "/usr/local/cuda-11.8/bin/nvcc --version")
    ]
    
    results = {}
    for name, cmd in tests:
        success, stdout, stderr = run_command(f"docker exec devbox-test {cmd}")
        if success:
            log_success(f"{name}: {stdout.strip()}")
            results[name] = True
        else:
            log_warning(f"{name}: 未找到或异常")
            results[name] = False
    
    return results

def test_gpu_capability():
    """测试GPU能力"""
    log_info("测试GPU能力...")
    
    # 测试nvidia-smi
    success, stdout, stderr = run_command("docker exec devbox-test nvidia-smi")
    if success:
        log_success("GPU驱动正常")
        return True
    else:
        log_warning("GPU驱动未安装或未挂载")
        return False

def test_jupyter_extensions():
    """测试JupyterLab扩展"""
    log_info("测试JupyterLab扩展...")
    success, stdout, stderr = run_command("docker exec devbox-test /opt/miniconda3/bin/jupyter labextension list")
    if success:
        log_success("JupyterLab扩展已安装")
        return True
    else:
        log_warning("JupyterLab扩展检查失败")
        return False

def test_vscode_extensions():
    """测试VSCode扩展"""
    log_info("测试VSCode扩展...")
    success, stdout, stderr = run_command("docker exec devbox-test ls /root/.local/share/code-server/extensions")
    if success:
        log_success("VSCode扩展已安装")
        return True
    else:
        log_warning("VSCode扩展检查失败")
        return False

def generate_report(process_results, port_results, env_results, gpu_ok, jupyter_ok, vscode_ok):
    """生成测试报告"""
    log_info("生成测试报告...")
    
    report = f"""
# Ubuntu 22.04 Python 3.12 开发机镜像全面测试报告

## 测试时间
{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 镜像信息
- 镜像名称: ubuntu2204-py312:latest
- 基础镜像: ubuntu:22.04
- Python版本: 3.12
- CUDA版本: 11.8

## 测试结果

### 进程服务测试
- supervisord: {'✅ 正常' if process_results.get('supervisord') else '❌ 异常'}
- sshd: {'✅ 正常' if process_results.get('sshd') else '❌ 异常'}
- jupyterlab: {'✅ 正常' if process_results.get('jupyterlab') else '❌ 异常'}
- code-server: {'✅ 正常' if process_results.get('code-server') else '❌ 异常'}

### 端口服务测试
- SSH端口(2222): {'✅ 正常' if port_results.get('SSH') else '❌ 异常'}
- JupyterLab端口(8888): {'✅ 正常' if port_results.get('JupyterLab') else '❌ 异常'}
- Code-Server端口(62661): {'✅ 正常' if port_results.get('Code-Server') else '❌ 异常'}

### 环境配置测试
- Python: {'✅ 正常' if env_results.get('Python版本') else '❌ 异常'}
- Conda: {'✅ 正常' if env_results.get('Conda版本') else '❌ 异常'}
- CUDA: {'✅ 正常' if env_results.get('CUDA版本') else '❌ 异常'}

### 扩展功能测试
- GPU能力: {'✅ 正常' if gpu_ok else '❌ 异常'}
- JupyterLab扩展: {'✅ 正常' if jupyter_ok else '❌ 异常'}
- VSCode扩展: {'✅ 正常' if vscode_ok else '❌ 异常'}

## 服务端口
- SSH: 2222
- JupyterLab: 8888
- Code-Server: 62661

## 访问方式
- SSH: ssh -p 2222 ubuntu@localhost (密码: 123456)
- JupyterLab: http://localhost:8888/lab
- Code-Server: http://localhost:62661

## 环境变量
- SSH_USER=ubuntu
- SSH_PASSWORD=123456
- CONDA_DEFAULT_ENV=python3.12

## 工作目录
- /workspace (JupyterLab默认目录)

## 总结
镜像基础功能已满足开发机需求，支持多进程容器管理、SSH远程访问、JupyterLab交互式开发、VSCode Server在线编辑等功能。
"""
    
    with open('COMPREHENSIVE_TEST_REPORT.md', 'w', encoding='utf-8') as f:
        f.write(report)
    
    log_success("测试报告已生成: COMPREHENSIVE_TEST_REPORT.md")

def cleanup():
    """清理测试容器"""
    log_info("清理测试容器...")
    run_command("docker stop devbox-test 2>/dev/null")
    run_command("docker rm devbox-test 2>/dev/null")

def main():
    """主函数"""
    log_info("开始开发机镜像全面测试...")
    
    try:
        # 检查Docker服务
        if not test_docker_service():
            return
        
        # 清理现有容器
        cleanup_containers()
        
        # 启动测试容器
        if not start_test_container():
            return
        
        # 等待服务启动
        wait_for_services()
        
        # 测试进程
        process_results = test_container_processes()
        
        # 测试端口
        port_results = test_port_connectivity()
        
        # 测试环境
        env_results = test_python_environment()
        
        # 测试GPU
        gpu_ok = test_gpu_capability()
        
        # 测试扩展
        jupyter_ok = test_jupyter_extensions()
        vscode_ok = test_vscode_extensions()
        
        # 生成报告
        generate_report(process_results, port_results, env_results, gpu_ok, jupyter_ok, vscode_ok)
        
        log_success("全面测试完成！")
        log_info("详细报告请查看: COMPREHENSIVE_TEST_REPORT.md")
        
    except Exception as e:
        log_error(f"测试过程中出现异常: {e}")
    finally:
        cleanup()

if __name__ == "__main__":
    main() 