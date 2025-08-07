@echo off
chcp 65001 >nul

:: 快速 SSH 连接脚本
:: 使用方法: quick_connect.bat [1|2]

set SERVER1_IP=43.135.68.39
set SERVER2_IP=43.132.192.253
set USERNAME=root
set PASSWORD=8pA!5DRAq#
set PORT=22

if "%1"=="" (
    echo 使用方法: %0 [1^|2]
    echo 1 - 连接到服务器 1 (%SERVER1_IP%)
    echo 2 - 连接到服务器 2 (%SERVER2_IP%)
    pause
    exit /b 1
)

if "%1"=="1" (
    echo 连接到服务器 1: %SERVER1_IP%
    ssh -p %PORT% %USERNAME%@%SERVER1_IP%
    exit /b 0
)

if "%1"=="2" (
    echo 连接到服务器 2: %SERVER2_IP%
    ssh -p %PORT% %USERNAME%@%SERVER2_IP%
    exit /b 0
)

echo 无效参数，请使用 1 或 2
pause 