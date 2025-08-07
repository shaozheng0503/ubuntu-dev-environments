# SSH 连接使用说明

## 1 服务器信息

### 1.1 服务器配置
- **服务器 1**: 43.135.68.39
- **服务器 2**: 43.132.192.253
- **用户名**: root
- **密码**: 8pA!5DRAq#
- **端口**: 22

## 2 连接方式

### 2.1 交互式连接脚本 (Linux/macOS)
使用 `ssh_connect.sh` 脚本进行交互式连接：

```bash
chmod +x ssh_connect.sh
./ssh_connect.sh
```

运行后会显示菜单，选择要连接的服务器。

### 2.2 直接连接脚本 (Linux/macOS)
使用 `ssh_direct.sh` 脚本直接连接指定服务器：

```bash
chmod +x ssh_direct.sh
./ssh_direct.sh 1  # 连接服务器 1
./ssh_direct.sh 2  # 连接服务器 2
```

### 2.3 PowerShell 脚本 (Windows)
在 Windows PowerShell 中运行：

```powershell
.\ssh_connect.ps1
```

### 2.4 批处理脚本 (Windows)
在 Windows 命令提示符中运行：

```cmd
ssh_connect.bat
```

### 2.5 快速连接脚本 (Windows)
直接连接指定服务器：

```cmd
quick_connect.bat 1  # 连接服务器 1
quick_connect.bat 2  # 连接服务器 2
```

### 2.6 手动 SSH 命令
也可以直接使用 SSH 命令连接：

```bash
# 连接服务器 1
ssh -p 22 root@43.135.68.39

# 连接服务器 2
ssh -p 22 root@43.132.192.253
```

## 3 注意事项

### 3.1 首次连接
首次连接到服务器时，SSH 客户端会询问是否信任服务器的主机密钥，输入 `yes` 确认。

### 3.2 密码认证
连接时会提示输入密码，使用提供的密码 `8pA!5DRAq#`。

### 3.3 连接问题排查
如果连接失败，请检查：
- 网络连接是否正常
- 服务器 IP 地址是否正确
- 22 端口是否开放
- 用户名和密码是否正确

## 4 安全建议

### 4.1 密码安全
建议定期更换密码，避免在公共网络中使用默认密码。

### 4.2 SSH 密钥认证
考虑配置 SSH 密钥认证以提高安全性，避免每次输入密码。

### 4.3 防火墙设置
确保服务器防火墙允许 22 端口的 SSH 连接。 