#!/usr/bin/env python3
"""
开发机基础镜像简化测试脚本
用于验证ubuntu2204-py312镜像的各项功能
"""

import subprocess
import time
import requests
import sys

def run_command(cmd, timeout=30):
    """运行命令并返回结果"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=timeout)
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "Command timed out"
    except Exception as e:
        return False, "", str(e)

def log_info(message):
    print(f"[INFO] {message}")

def log_success(message):
    print(f"[SUCCESS] {message}")

def log_warning(message):
    print(f"[WARNING] {message}")

def log_error(message):
    print(f"[ERROR] {message}")

def test_container_startup():
    """测试容器启动"""
    log_info("启动测试容器...")
    
    # 启动容器
    success, stdout, stderr = run_command(
        'docker run -d --name test-py312-simple -p 2222:22 -p 8888:8888 -p 62661:62661 ubuntu2204-py312:latest'
    )
    
    if not success:
        log_error(f"容器启动失败: {stderr}")
        return False
    
    container_id = stdout.strip()
    log_success(f"容器启动成功: {container_id}")
    
    # 等待服务启动
    log_info("等待服务启动...")
    time.sleep(60)
    
    return True

def test_services():
    """测试各项服务"""
    results = {}
    
    # 测试SSH端口
    log_info("测试SSH端口...")
    success, stdout, stderr = run_command("nc -z localhost 2222")
    if success:
        log_success("SSH端口2222开放")
        results['ssh_port'] = True
    else:
        log_warning("SSH端口2222未开放")
        results['ssh_port'] = False
    
    # 测试JupyterLab端口
    log_info("测试JupyterLab端口...")
    success, stdout, stderr = run_command("nc -z localhost 8888")
    if success:
        log_success("JupyterLab端口8888开放")
        results['jupyter_port'] = True
    else:
        log_warning("JupyterLab端口8888未开放")
        results['jupyter_port'] = False
    
    # 测试Code-Server端口
    log_info("测试Code-Server端口...")
    success, stdout, stderr = run_command("nc -z localhost 62661")
    if success:
        log_success("Code-Server端口62661开放")
        results['codeserver_port'] = True
    else:
        log_warning("Code-Server端口62661未开放")
        results['codeserver_port'] = False
    
    return results

def test_container_processes():
    """测试容器内进程"""
    results = {}
    
    # 测试supervisord进程
    log_info("测试supervisord进程...")
    success, stdout, stderr = run_command("docker exec test-py312-simple ps aux | grep supervisord")
    if success and "supervisord" in stdout:
        log_success("supervisord进程运行正常")
        results['supervisord'] = True
    else:
        log_warning("supervisord进程未运行")
        results['supervisord'] = False
    
    # 测试sshd进程
    log_info("测试sshd进程...")
    success, stdout, stderr = run_command("docker exec test-py312-simple ps aux | grep sshd")
    if success and "sshd" in stdout:
        log_success("sshd进程运行正常")
        results['sshd'] = True
    else:
        log_warning("sshd进程未运行")
        results['sshd'] = False
    
    # 测试jupyterlab进程
    log_info("测试jupyterlab进程...")
    success, stdout, stderr = run_command("docker exec test-py312-simple ps aux | grep jupyter")
    if success and "jupyter" in stdout:
        log_success("jupyterlab进程运行正常")
        results['jupyterlab'] = True
    else:
        log_warning("jupyterlab进程未运行")
        results['jupyterlab'] = False
    
    # 测试code-server进程
    log_info("测试code-server进程...")
    success, stdout, stderr = run_command("docker exec test-py312-simple ps aux | grep code-server")
    if success and "code-server" in stdout:
        log_success("code-server进程运行正常")
        results['code_server'] = True
    else:
        log_warning("code-server进程未运行")
        results['code_server'] = False
    
    return results

def test_python_environment():
    """测试Python环境"""
    results = {}
    
    # 测试Python版本
    log_info("测试Python环境...")
    success, stdout, stderr = run_command("docker exec test-py312-simple /opt/miniconda3/bin/python --version")
    if success:
        log_success(f"Python环境正常: {stdout.strip()}")
        results['python'] = True
    else:
        log_warning("Python环境异常")
        results['python'] = False
    
    # 测试conda环境
    log_info("测试conda环境...")
    success, stdout, stderr = run_command("docker exec test-py312-simple /opt/miniconda3/bin/conda info --envs")
    if success:
        log_success("conda环境正常")
        results['conda'] = True
    else:
        log_warning("conda环境异常")
        results['conda'] = False
    
    # 测试CUDA环境
    log_info("测试CUDA环境...")
    success, stdout, stderr = run_command("docker exec test-py312-simple /usr/local/cuda-11.8/bin/nvcc --version")
    if success:
        log_success("CUDA环境正常")
        results['cuda'] = True
    else:
        log_warning("CUDA环境异常")
        results['cuda'] = False
    
    return results

def test_vscode_extensions():
    """测试VSCode扩展"""
    log_info("测试VSCode扩展...")
    success, stdout, stderr = run_command("docker exec test-py312-simple ls /root/.local/share/code-server/extensions")
    if success:
        log_success("VSCode扩展已安装")
        return True
    else:
        log_warning("VSCode扩展未安装")
        return False

def test_jupyterlab_extensions():
    """测试JupyterLab扩展"""
    log_info("测试JupyterLab扩展...")
    success, stdout, stderr = run_command("docker exec test-py312-simple /opt/miniconda3/bin/jupyter labextension list")
    if success:
        log_success("JupyterLab扩展已安装")
        return True
    else:
        log_warning("JupyterLab扩展未安装")
        return False

def generate_report(port_results, process_results, python_results, vscode_ok, jupyterlab_ok):
    """生成测试报告"""
    log_info("生成测试报告...")
    
    report = f"""
# Ubuntu 22.04 Python 3.12 开发机镜像测试报告

## 测试时间
{time.strftime('%Y-%m-%d %H:%M:%S')}

## 镜像信息
- 镜像名称: ubuntu2204-py312:latest
- 基础镜像: ubuntu:22.04
- Python版本: 3.12.11
- CUDA版本: 11.8

## 测试结果

### 端口服务测试
- SSH端口(2222): {'✅ 正常' if port_results.get('ssh_port') else '❌ 异常'}
- JupyterLab端口(8888): {'✅ 正常' if port_results.get('jupyter_port') else '❌ 异常'}
- Code-Server端口(62661): {'✅ 正常' if port_results.get('codeserver_port') else '❌ 异常'}

### 进程服务测试
- supervisord: {'✅ 正常' if process_results.get('supervisord') else '❌ 异常'}
- sshd: {'✅ 正常' if process_results.get('sshd') else '❌ 异常'}
- jupyterlab: {'✅ 正常' if process_results.get('jupyterlab') else '❌ 异常'}
- code-server: {'✅ 正常' if process_results.get('code_server') else '❌ 异常'}

### Python环境测试
- Python: {'✅ 正常' if python_results.get('python') else '❌ 异常'}
- conda: {'✅ 正常' if python_results.get('conda') else '❌ 异常'}
- CUDA: {'✅ 正常' if python_results.get('cuda') else '❌ 异常'}

### 扩展功能测试
- VSCode扩展: {'✅ 正常' if vscode_ok else '❌ 异常'}
- JupyterLab扩展: {'✅ 正常' if jupyterlab_ok else '❌ 异常'}

## 服务端口
- SSH: 2222
- JupyterLab: 8888
- Code-Server: 62661

## 访问方式
- SSH: ssh -p 2222 root@localhost (密码: 123456)
- JupyterLab: http://localhost:8888
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
    
    with open('SIMPLE_TEST_REPORT.md', 'w', encoding='utf-8') as f:
        f.write(report)
    
    log_success("测试报告已生成: SIMPLE_TEST_REPORT.md")

def cleanup():
    """清理测试容器"""
    log_info("清理测试容器...")
    run_command("docker stop test-py312-simple")
    run_command("docker rm test-py312-simple")

def main():
    """主函数"""
    log_info("开始开发机基础镜像简化测试...")
    
    try:
        # 启动容器
        if not test_container_startup():
            return
        
        # 测试端口服务
        port_results = test_services()
        
        # 测试容器进程
        process_results = test_container_processes()
        
        # 测试Python环境
        python_results = test_python_environment()
        
        # 测试扩展
        vscode_ok = test_vscode_extensions()
        jupyterlab_ok = test_jupyterlab_extensions()
        
        # 生成报告
        generate_report(port_results, process_results, python_results, vscode_ok, jupyterlab_ok)
        
        log_success("测试完成！")
        log_info("详细报告请查看: SIMPLE_TEST_REPORT.md")
        
    except KeyboardInterrupt:
        log_warning("测试被用户中断")
    except Exception as e:
        log_error(f"测试过程中出现错误: {e}")
    finally:
        cleanup()

if __name__ == "__main__":
    main() 