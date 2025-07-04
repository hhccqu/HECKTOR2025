#!/bin/bash

# HECKTOR2025 nnU-Net 服务器部署脚本

set -e

echo "=========================================="
echo "HECKTOR2025 nnU-Net 服务器部署"
echo "=========================================="

# 设置环境变量
export nnUNet_raw="$HOME/nnUNet_raw"
export nnUNet_preprocessed="$HOME/nnUNet_preprocessed"
export nnUNet_results="$HOME/nnUNet_results"

echo "nnU-Net 环境变量:"
echo "  nnUNet_raw: $nnUNet_raw"
echo "  nnUNet_preprocessed: $nnUNet_preprocessed"
echo "  nnUNet_results: $nnUNet_results"

# 创建目录
mkdir -p "$nnUNet_raw"
mkdir -p "$nnUNet_preprocessed"
mkdir -p "$nnUNet_results"

# 复制数据集
echo "复制数据集到 $nnUNet_raw..."
cp -r Dataset101_HECKTOR2025 "$nnUNet_raw/"

# 验证数据集
echo "验证数据集..."
DATASET_PATH="$nnUNet_raw/Dataset101_HECKTOR2025"
if [ -f "$DATASET_PATH/dataset.json" ]; then
    echo "✅ 找到dataset.json"
else
    echo "❌ 缺少dataset.json"
    exit 1
fi

IMAGE_COUNT=$(find "$DATASET_PATH/imagesTr" -name "*.nii.gz" | wc -l)
LABEL_COUNT=$(find "$DATASET_PATH/labelsTr" -name "*.nii.gz" | wc -l)

echo "数据集统计:"
echo "  图像文件: $IMAGE_COUNT"
echo "  标签文件: $LABEL_COUNT"

if [ "$IMAGE_COUNT" -ne "$LABEL_COUNT" ]; then
    echo "警告: 图像和标签文件数量不匹配"
fi

# 运行预处理
echo "开始nnU-Net预处理..."
nnUNetv2_plan_and_preprocess -d 101 --verify_dataset_integrity

# 检查GPU
echo "检查GPU状态..."
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
    GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | head -1)
    echo "可用GPU数量: $GPU_COUNT"
else
    echo "未检测到GPU，将使用CPU训练"
    GPU_COUNT=0
fi

# 开始训练
echo "开始训练..."
echo "命令: nnUNetv2_train 101 3d_fullres 0"

# 如果有GPU，使用GPU训练
if [ "$GPU_COUNT" -gt 0 ]; then
    echo "使用GPU训练..."
    CUDA_VISIBLE_DEVICES=0 nnUNetv2_train 101 3d_fullres 0
else
    echo "使用CPU训练..."
    nnUNetv2_train 101 3d_fullres 0
fi

echo "训练完成!"
echo "结果保存在: $nnUNet_results/Dataset101_HECKTOR2025" 