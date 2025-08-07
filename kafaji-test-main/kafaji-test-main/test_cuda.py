#!/usr/bin/env python3
"""
CUDA和PyTorch GPU验证脚本
用于验证开发机镜像中的GPU支持是否正常工作
"""

import torch

# 1. 检查CUDA（NVIDIA GPU）是否可用
if torch.cuda.is_available():
    print("CUDA (NVIDIA GPU) is available!")

    # 2. 获取可用的GPU数量
    gpu_count = torch.cuda.device_count()
    print(f"Number of available GPUs: {gpu_count}")
    print("-" * 30)

    # 3. 遍历所有GPU并打印其型号和详细信息
    for i in range(gpu_count):
        print(f"--- GPU {i} ---")
        # 获取GPU型号
        print(f"Device Name: {torch.cuda.get_device_name(i)}")
        # 获取当前选定的设备（通常默认为0）
        # print(f"Current Device: {torch.cuda.current_device()}")

        # 获取设备属性
        props = torch.cuda.get_device_properties(i)
        print(f"  Compute Capability: {props.major}.{props.minor}")
        total_memory_gb = props.total_memory / (1024**3)
        print(f"  Total Memory: {total_memory_gb:.2f} GB")

else:
    print("CUDA (NVIDIA GPU) is not available.")

print("-" * 30)

# 4. 检查Apple Silicon (M1/M2/M3) GPU (MPS Backend) 是否可用 (适用于 PyTorch 1.12+)
# PyTorch 2.x 及以上版本对 MPS 的支持更加完善
if torch.backends.mps.is_available():
    print("MPS (Apple Silicon GPU) is available!")
    # MPS 只有一个设备，即集成的 GPU
    print("Number of available MPS devices: 1")
    # 注意：PyTorch 目前没有提供直接获取 Apple Silicon 型号的API，
    # 你需要从操作系统层面查看（例如 "关于本机"）。
    
    # 检查MPS后端是否已经构建好
    if not torch.backends.mps.is_built():
         print("MPS not available because the current PyTorch install was not "
               "built with MPS enabled.")
else:
    print("MPS (Apple Silicon GPU) is not available.")


print("-" * 30)
# 5. CPU 总是可用的
print("CPU is always available.")

# 你可以这样定义device对象，以便在代码中灵活切换
if torch.cuda.is_available():
    device = torch.device("cuda")
elif torch.backends.mps.is_available():
    device = torch.device("mps")
else:
    device = torch.device("cpu")

print(f"\nRecommended device to use: {device}") 