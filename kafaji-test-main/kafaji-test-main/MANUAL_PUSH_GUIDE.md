# 📋 手动推送指南

由于终端环境问题，请按照以下步骤手动推送文件到GitHub：

## 🚀 步骤1: 检查Git配置

```bash
# 检查Git是否安装
git --version

# 检查Git配置
git config --list

# 设置用户信息（如果未设置）
git config --global user.name "您的GitHub用户名"
git config --global user.email "您的邮箱"
```

## 🚀 步骤2: 初始化仓库

```bash
# 进入项目目录
cd H:\kaifaji\base\ubuntu\2204-711

# 初始化Git仓库
git init

# 添加远程仓库
git remote add origin https://github.com/shaozheng0503/kafaji-test.git

# 检查远程仓库
git remote -v
```

## 🚀 步骤3: 添加文件

```bash
# 添加所有py312相关文件
git add ubuntu2204-py312
git add ubuntu2204-py312-pytorch
git add ubuntu2204-py312-tensorflow
git add simple_test.py
git add comprehensive_test.py
git add supervisord_detailed_test.py
git add build_image.sh
git add build_all_images.sh
git add rebuild_with_new_ports.sh
git add test_devbox.sh
git add test_cuda.py
git add config/supervisord.conf
git add init/init.sh
git add README.md
git add LICENSE
git add .gitignore
```

## 🚀 步骤4: 提交更改

```bash
# 提交所有更改
git commit -m "feat: 添加Python 3.12开发机镜像

- 添加ubuntu2204-py312基础镜像
- 添加PyTorch和TensorFlow专用镜像
- 添加完整的测试套件
- 更新README.md文档
- 添加MIT许可证
- 优化Supervisord配置
- 支持SSH、JupyterLab、VSCode服务"
```

## 🚀 步骤5: 推送到GitHub

```bash
# 推送到main分支
git push -u origin main

# 如果遇到认证问题，使用个人访问令牌
# 在GitHub设置中生成Personal Access Token
git push https://YOUR_TOKEN@github.com/shaozheng0503/kafaji-test.git main
```

## 🔧 常见问题解决

### 问题1: 认证失败
```bash
# 使用GitHub CLI登录
gh auth login

# 或者使用个人访问令牌
git remote set-url origin https://YOUR_TOKEN@github.com/shaozheng0503/kafaji-test.git
```

### 问题2: 分支不存在
```bash
# 创建并切换到main分支
git checkout -b main

# 或者推送到master分支
git push -u origin master
```

### 问题3: 文件太大
```bash
# 检查大文件
git ls-files | xargs ls -la | sort -k5 -nr | head -10

# 如果code-server.tar.gz太大，可以排除
echo "code-server.tar.gz" >> .gitignore
git add .gitignore
git commit -m "chore: 排除大文件"
```

## 📋 推送文件清单

### ✅ 核心镜像文件
- `ubuntu2204-py312` - 基础开发机镜像
- `ubuntu2204-py312-pytorch` - PyTorch专用镜像
- `ubuntu2204-py312-tensorflow` - TensorFlow专用镜像

### ✅ 测试脚本
- `simple_test.py` - 快速测试脚本
- `comprehensive_test.py` - 完整测试套件
- `supervisord_detailed_test.py` - Supervisord专项测试
- `test_devbox.sh` - Shell测试脚本
- `test_cuda.py` - CUDA功能测试

### ✅ 构建脚本
- `build_image.sh` - 单镜像构建脚本
- `build_all_images.sh` - 批量构建脚本
- `rebuild_with_new_ports.sh` - 端口更新重建脚本

### ✅ 配置文件
- `config/supervisord.conf` - Supervisord配置
- `init/init.sh` - 初始化脚本

### ✅ 文档文件
- `README.md` - 项目主文档
- `LICENSE` - MIT许可证
- `.gitignore` - Git忽略文件

## 🎯 验证推送结果

推送成功后，访问以下地址验证：
- **仓库地址**: https://github.com/shaozheng0503/kafaji-test
- **文件列表**: 检查所有文件是否已上传
- **README显示**: 确认README.md正确显示

## 📞 获取帮助

如果遇到问题，可以：
1. 查看Git错误信息
2. 检查网络连接
3. 验证GitHub权限
4. 确认仓库地址正确

---

**🎉 按照以上步骤操作，应该可以成功推送到GitHub！** 