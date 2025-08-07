# PowerShell SSH 自动连接脚本
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("1", "2")]
    [string]$Server
)

# 服务器配置
$servers = @{
    "1" = @{
        IP = "43.135.68.39"
        Name = "服务器 1"
    }
    "2" = @{
        IP = "43.132.192.253"
        Name = "服务器 2"
    }
}

$username = "root"
$password = "8pA!5DRAq#"
$port = "22"

$serverInfo = $servers[$Server]
Write-Host "正在连接到 $($serverInfo.Name): $($serverInfo.IP)" -ForegroundColor Green

# 构建 SSH 命令
$sshArgs = @(
    "-o", "StrictHostKeyChecking=no",
    "-p", $port,
    "$username@$($serverInfo.IP)"
)

Write-Host "SSH 命令: ssh $($sshArgs -join ' ')" -ForegroundColor Yellow
Write-Host "用户名: $username" -ForegroundColor Cyan
Write-Host "密码: $password" -ForegroundColor Cyan
Write-Host ""

# 启动 SSH 进程
try {
    $process = Start-Process -FilePath "ssh" -ArgumentList $sshArgs -NoNewWindow -PassThru
    Write-Host "SSH 进程已启动，PID: $($process.Id)" -ForegroundColor Green
    
    # 等待用户手动输入密码
    Write-Host "请在 SSH 提示时输入密码: $password" -ForegroundColor Yellow
    Write-Host "按任意键继续..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    # 等待进程完成
    $process.WaitForExit()
    Write-Host "SSH 连接已结束" -ForegroundColor Green
}
catch {
    Write-Host "连接失败: $($_.Exception.Message)" -ForegroundColor Red
} 