# Windows PowerShell SSH 连接脚本

# 服务器信息
$SERVER1_IP = "43.135.68.39"
$SERVER2_IP = "43.132.192.253"
$USERNAME = "root"
$PASSWORD = "8pA!5DRAq#"
$PORT = "22"

Write-Host "=== SSH 连接工具 ===" -ForegroundColor Green
Write-Host "请选择要连接的服务器：" -ForegroundColor Yellow
Write-Host "1. 服务器 1 ($SERVER1_IP)" -ForegroundColor Cyan
Write-Host "2. 服务器 2 ($SERVER2_IP)" -ForegroundColor Cyan
Write-Host "3. 退出" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "请输入选择 (1-3)"

switch ($choice) {
    "1" {
        Write-Host "正在连接到服务器 1: $SERVER1_IP" -ForegroundColor Green
        ssh -p $PORT ${USERNAME}@$SERVER1_IP
    }
    "2" {
        Write-Host "正在连接到服务器 2: $SERVER2_IP" -ForegroundColor Green
        ssh -p $PORT ${USERNAME}@$SERVER2_IP
    }
    "3" {
        Write-Host "退出连接工具" -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host "无效选择，请重新运行脚本" -ForegroundColor Red
        exit 1
    }
} 