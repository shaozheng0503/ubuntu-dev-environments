# SSH 连接工具集

这是一个用于快速连接 SSH 服务器的工具集，支持多个服务器管理和多种连接方式。

## 文件说明

### 连接脚本
- `ssh_connect.sh` - Linux/macOS 交互式连接脚本
- `ssh_direct.sh` - Linux/macOS 直接连接脚本
- `ssh_connect.ps1` - Windows PowerShell 连接脚本
- `ssh_connect.bat` - Windows 批处理连接脚本
- `quick_connect.bat` - Windows 快速连接脚本

### 配置文件
- `servers.conf` - 服务器配置文件
- `SSH_连接说明.md` - 详细使用说明

## 服务器信息

| 服务器 | IP 地址 | 用户名 | 密码 | 端口 |
|--------|----------|--------|------|------|
| 服务器 1 | 43.135.68.39 | root | 8pA!5DRAq# | 22 |
| 服务器 2 | 43.132.192.253 | root | 8pA!5DRAq# | 22 |

## 快速开始

### Windows 用户
```cmd
# 交互式连接
ssh_connect.bat

# 快速连接
quick_connect.bat 1  # 连接服务器 1
quick_connect.bat 2  # 连接服务器 2
```

### Linux/macOS 用户
```bash
# 交互式连接
chmod +x ssh_connect.sh
./ssh_connect.sh

# 直接连接
chmod +x ssh_direct.sh
./ssh_direct.sh 1  # 连接服务器 1
./ssh_direct.sh 2  # 连接服务器 2
```

### PowerShell 用户
```powershell
.\ssh_connect.ps1
```

## 注意事项

1. 首次连接时可能需要确认服务器主机密钥
2. 确保本地已安装 SSH 客户端
3. 确保网络连接正常
4. 建议定期更换密码以提高安全性

详细使用说明请参考 `SSH_连接说明.md` 文件。 