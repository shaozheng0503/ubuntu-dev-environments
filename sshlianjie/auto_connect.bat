@echo off
chcp 65001 >nul

:: 自动 SSH 连接脚本
set SERVER1_IP=43.135.68.39
set SERVER2_IP=43.132.192.253
set USERNAME=root
set PASSWORD=8pA!5DRAq#
set PORT=22

echo 正在尝试连接服务器 1: %SERVER1_IP%
echo 密码: %PASSWORD%
echo.

:: 使用 PowerShell 的 Start-Process 来执行 SSH
powershell -Command "& { $process = Start-Process -FilePath 'ssh' -ArgumentList '-p', '%PORT%', '%USERNAME%@%SERVER1_IP%' -NoNewWindow -PassThru; Start-Sleep -Seconds 2; $process.WaitForExit() }"

echo.
echo 连接完成或失败。
pause 