# 监控 Docker 构建进度
Write-Host "🔍 监控 Docker 构建进度..." -ForegroundColor Green

while ($true) {
    Clear-Host
    Write-Host "=== Docker 构建监控 ===" -ForegroundColor Cyan
    Write-Host "时间: $(Get-Date)" -ForegroundColor Yellow
    
    # 检查镜像是否存在
    $image = docker images | Select-String "ubuntu2204-py312-pytorch"
    if ($image) {
        Write-Host "✅ 镜像构建完成!" -ForegroundColor Green
        Write-Host $image
        break
    } else {
        Write-Host "⏳ 镜像构建中..." -ForegroundColor Yellow
    }
    
    # 检查 Docker 进程
    $dockerProcesses = Get-Process | Where-Object {$_.ProcessName -like "*docker*"}
    Write-Host "`n🐳 Docker 进程:" -ForegroundColor Blue
    foreach ($proc in $dockerProcesses) {
        Write-Host "  - $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor White
    }
    
    # 检查系统资源
    $cpu = Get-Counter "\Processor(_Total)\% Processor Time" | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    $memory = Get-Counter "\Memory\Available MBytes" | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    
    Write-Host "`n💻 系统资源:" -ForegroundColor Blue
    Write-Host "  - CPU 使用率: $([math]::Round($cpu, 1))%" -ForegroundColor White
    Write-Host "  - 可用内存: $([math]::Round($memory, 0)) MB" -ForegroundColor White
    
    # 检查 Docker 系统状态
    Write-Host "`n📊 Docker 系统状态:" -ForegroundColor Blue
    docker system df 2>$null | Select-String -Pattern "Build Cache" | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor White
    }
    
    Write-Host "`n⏰ 等待 10 秒后重新检查..." -ForegroundColor Gray
    Start-Sleep -Seconds 10
} 