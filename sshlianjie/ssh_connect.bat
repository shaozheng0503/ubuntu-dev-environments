@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: SSH 连接脚本 - Windows 批处理版本
:: 服务器信息
set SERVER1_IP=43.135.68.39
set SERVER2_IP=43.132.192.253
set USERNAME=root
set PASSWORD=8pA!5DRAq#
set PORT=22

echo === SSH 连接工具 ===
echo 请选择要连接的服务器：
echo 1. 服务器 1 (%SERVER1_IP%)
echo 2. 服务器 2 (%SERVER2_IP%)
echo 3. 退出
echo.

set /p choice=请输入选择 (1-3): 

if "%choice%"=="1" (
    echo 正在连接到服务器 1: %SERVER1_IP%
    ssh -p %PORT% %USERNAME%@%SERVER1_IP%
    goto :eof
)

if "%choice%"=="2" (
    echo 正在连接到服务器 2: %SERVER2_IP%
    ssh -p %PORT% %USERNAME%@%SERVER2_IP%
    goto :eof
)

if "%choice%"=="3" (
    echo 退出连接工具
    goto :eof
)

echo 无效选择，请重新运行脚本
pause 