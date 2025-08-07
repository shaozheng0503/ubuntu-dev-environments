@echo off
chcp 65001 >nul
echo 🚀 开始推送py312相关文件到GitHub...

REM 检查git状态
echo [INFO] 检查git状态...
git status >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 当前目录不是git仓库
    pause
    exit /b 1
)

REM 添加py312相关文件
echo [INFO] 添加py312相关文件...

REM 核心文件
git add ubuntu2204-py312
git add ubuntu2204-py312-pytorch
git add ubuntu2204-py312-tensorflow

REM 测试脚本
git add simple_test.py
git add comprehensive_test.py
git add supervisord_detailed_test.py

REM 构建脚本
git add build_image.sh
git add build_all_images.sh
git add rebuild_with_new_ports.sh

REM 测试脚本
git add test_devbox.sh
git add test_cuda.py

REM 配置文件
git add config/supervisord.conf
git add init/init.sh

REM 文档文件
git add README.md
git add LICENSE
git add .gitignore

REM 检查添加的文件
echo [INFO] 检查添加的文件...
git status --porcelain

REM 提交更改
echo [INFO] 提交更改...
git commit -m "feat: 添加Python 3.12开发机镜像

- 添加ubuntu2204-py312基础镜像
- 添加PyTorch和TensorFlow专用镜像
- 添加完整的测试套件
- 更新README.md文档
- 添加MIT许可证
- 优化Supervisord配置
- 支持SSH、JupyterLab、VSCode服务"

REM 推送到远程仓库
echo [INFO] 推送到远程仓库...
git push origin main

if errorlevel 0 (
    echo [SUCCESS] ✅ 推送成功！
    echo [INFO] 🌐 访问地址: https://github.com/shaozheng0503/kafaji-test
) else (
    echo [ERROR] ❌ 推送失败，请检查网络连接和权限
    pause
    exit /b 1
)

echo.
echo [INFO] 📋 推送的文件列表:
echo   ✅ ubuntu2204-py312 - 基础镜像Dockerfile
echo   ✅ ubuntu2204-py312-pytorch - PyTorch镜像
echo   ✅ ubuntu2204-py312-tensorflow - TensorFlow镜像
echo   ✅ simple_test.py - 快速测试脚本
echo   ✅ comprehensive_test.py - 完整测试脚本
echo   ✅ supervisord_detailed_test.py - Supervisord专项测试
echo   ✅ build_image.sh - 镜像构建脚本
echo   ✅ build_all_images.sh - 批量构建脚本
echo   ✅ test_devbox.sh - 开发机测试脚本
echo   ✅ config/supervisord.conf - Supervisord配置
echo   ✅ init/init.sh - 初始化脚本
echo   ✅ README.md - 项目文档
echo   ✅ LICENSE - MIT许可证
echo   ✅ .gitignore - Git忽略文件

echo.
echo [SUCCESS] 🎉 所有py312相关文件已成功推送到GitHub！
pause 