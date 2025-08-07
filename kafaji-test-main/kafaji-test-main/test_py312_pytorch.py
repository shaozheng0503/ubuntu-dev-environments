#!/usr/bin/env python3
"""
PyTorch 2.7.1 + Python 3.12 测试脚本
"""

import sys
import torch
import torchvision
import torchaudio

def test_pytorch_installation():
    """测试 PyTorch 安装"""
    print("=" * 50)
    print("PyTorch 2.7.1 + Python 3.12 测试")
    print("=" * 50)
    
    # 检查 Python 版本
    print(f"Python 版本: {sys.version}")
    print(f"Python 路径: {sys.executable}")
    
    # 检查 PyTorch 版本
    print(f"PyTorch 版本: {torch.__version__}")
    print(f"TorchVision 版本: {torchvision.__version__}")
    print(f"TorchAudio 版本: {torchaudio.__version__}")
    
    # 检查 CUDA 支持
    print(f"CUDA 可用: {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        print(f"CUDA 版本: {torch.version.cuda}")
        print(f"cuDNN 版本: {torch.backends.cudnn.version()}")
        print(f"GPU 数量: {torch.cuda.device_count()}")
        for i in range(torch.cuda.device_count()):
            print(f"GPU {i}: {torch.cuda.get_device_name(i)}")
    
    # 测试基本张量操作
    print("\n测试基本张量操作:")
    x = torch.randn(3, 3)
    print(f"随机张量:\n{x}")
    
    if torch.cuda.is_available():
        print("\n测试 GPU 张量操作:")
        x_gpu = x.cuda()
        print(f"GPU 张量:\n{x_gpu}")
        print(f"张量设备: {x_gpu.device}")
    
    # 测试自动微分
    print("\n测试自动微分:")
    x = torch.tensor([2.0], requires_grad=True)
    y = x ** 2 + 3 * x + 1
    y.backward()
    print(f"x = {x.item()}, y = {y.item()}, dy/dx = {x.grad.item()}")
    
    print("\n✅ PyTorch 安装测试完成!")

def test_jupyter_environment():
    """测试 Jupyter 环境"""
    print("\n" + "=" * 50)
    print("Jupyter 环境测试")
    print("=" * 50)
    
    try:
        import jupyterlab
        print(f"JupyterLab 版本: {jupyterlab.__version__}")
    except ImportError:
        print("❌ JupyterLab 未安装")
    
    try:
        import ipykernel
        print(f"IPyKernel 版本: {ipykernel.__version__}")
    except ImportError:
        print("❌ IPyKernel 未安装")
    
    try:
        import ipympl
        print("✅ ipympl 已安装")
    except ImportError:
        print("❌ ipympl 未安装")

if __name__ == "__main__":
    test_pytorch_installation()
    test_jupyter_environment() 