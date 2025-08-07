#!/bin/bash

# 推送脚本 - 将py312相关文件推送到GitHub
# 使用方法: bash push_to_github.sh

echo "🚀 开始推送py312相关文件到GitHub..."

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查git状态
log_info "检查git状态..."
if ! git status > /dev/null 2>&1; then
    log_error "当前目录不是git仓库"
    exit 1
fi

# 添加py312相关文件
log_info "添加py312相关文件..."

# 核心文件
git add ubuntu2204-py312
git add ubuntu2204-py312-pytorch
git add ubuntu2204-py312-tensorflow

# 测试脚本
git add simple_test.py
git add comprehensive_test.py
git add supervisord_detailed_test.py

# 构建脚本
git add build_image.sh
git add build_all_images.sh
git add rebuild_with_new_ports.sh

# 测试脚本
git add test_devbox.sh
git add test_cuda.py

# 配置文件
git add config/supervisord.conf
git add init/init.sh

# 文档文件
git add README.md
git add LICENSE
git add .gitignore

# 检查添加的文件
log_info "检查添加的文件..."
git status --porcelain

# 提交更改
log_info "提交更改..."
git commit -m "feat: 添加Python 3.12开发机镜像

- 添加ubuntu2204-py312基础镜像
- 添加PyTorch和TensorFlow专用镜像
- 添加完整的测试套件
- 更新README.md文档
- 添加MIT许可证
- 优化Supervisord配置
- 支持SSH、JupyterLab、VSCode服务"

# 推送到远程仓库
log_info "推送到远程仓库..."
git push origin main

if [ $? -eq 0 ]; then
    log_success "✅ 推送成功！"
    log_info "🌐 访问地址: https://github.com/shaozheng0503/kafaji-test"
else
    log_error "❌ 推送失败，请检查网络连接和权限"
    exit 1
fi

echo ""
log_info "📋 推送的文件列表:"
echo "  ✅ ubuntu2204-py312 - 基础镜像Dockerfile"
echo "  ✅ ubuntu2204-py312-pytorch - PyTorch镜像"
echo "  ✅ ubuntu2204-py312-tensorflow - TensorFlow镜像"
echo "  ✅ simple_test.py - 快速测试脚本"
echo "  ✅ comprehensive_test.py - 完整测试脚本"
echo "  ✅ supervisord_detailed_test.py - Supervisord专项测试"
echo "  ✅ build_image.sh - 镜像构建脚本"
echo "  ✅ build_all_images.sh - 批量构建脚本"
echo "  ✅ test_devbox.sh - 开发机测试脚本"
echo "  ✅ config/supervisord.conf - Supervisord配置"
echo "  ✅ init/init.sh - 初始化脚本"
echo "  ✅ README.md - 项目文档"
echo "  ✅ LICENSE - MIT许可证"
echo "  ✅ .gitignore - Git忽略文件"

echo ""
log_success "🎉 所有py312相关文件已成功推送到GitHub！" 