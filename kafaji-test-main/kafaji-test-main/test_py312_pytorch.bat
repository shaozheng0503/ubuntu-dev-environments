@echo off
echo 🧪 开始测试 ubuntu2204-py312-pytorch 镜像...

set IMAGE_NAME=ubuntu2204-py312-pytorch
set CONTAINER_NAME=test-py312-pytorch

REM 检查镜像是否存在
docker images | findstr "%IMAGE_NAME%" >nul
if errorlevel 1 (
    echo ❌ 镜像 %IMAGE_NAME% 不存在，请先构建镜像
    exit /b 1
)

REM 停止并删除已存在的测试容器
docker stop %CONTAINER_NAME% 2>nul
docker rm %CONTAINER_NAME% 2>nul

REM 启动测试容器
echo 🚀 启动测试容器...
docker run -d --name %CONTAINER_NAME% ^
    -p 2222:22 ^
    -p 8888:8888 ^
    -p 62661:62661 ^
    --gpus all ^
    %IMAGE_NAME%:latest

REM 等待容器启动
echo ⏳ 等待容器启动...
timeout /t 10 /nobreak >nul

REM 测试 Python 版本
echo 🐍 测试 Python 版本...
docker exec %CONTAINER_NAME% python --version

REM 测试 PyTorch 安装
echo 🔥 测试 PyTorch 安装...
docker exec %CONTAINER_NAME% python -c "import torch; import torchvision; import torchaudio; print(f'PyTorch: {torch.__version__}'); print(f'TorchVision: {torchvision.__version__}'); print(f'TorchAudio: {torchaudio.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}')"

REM 测试 CUDA 功能
echo 🎮 测试 CUDA 功能...
docker exec %CONTAINER_NAME% python -c "import torch; print('CUDA available:' if torch.cuda.is_available() else 'CUDA not available')"

REM 测试 JupyterLab
echo 📓 测试 JupyterLab...
docker exec %CONTAINER_NAME% jupyter lab --version

REM 测试 VSCode Server
echo 💻 测试 VSCode Server...
docker exec %CONTAINER_NAME% code-server --version

REM 测试服务状态
echo 🔍 检查服务状态...
docker exec %CONTAINER_NAME% supervisorctl status

REM 清理测试容器
echo 🧹 清理测试容器...
docker stop %CONTAINER_NAME%
docker rm %CONTAINER_NAME%

echo ✅ 测试完成！
echo.
echo 访问地址:
echo - JupyterLab: http://localhost:8888
echo - VSCode Server: http://localhost:62661
echo - SSH: ssh root@localhost -p 2222 (密码: 123456) 