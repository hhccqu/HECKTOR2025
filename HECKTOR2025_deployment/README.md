# HECKTOR2025 nnU-Net 部署包

## 📦 包含内容

- `Dataset101_HECKTOR2025/` - nnU-Net格式的数据集
- `deploy_server.sh` - 服务器部署脚本
- `upload_to_server.bat` - Windows上传脚本
- `README.md` - 使用说明

## 🚀 部署步骤

### 1. 上传到服务器

**方法1: 使用上传脚本**
```bash
upload_to_server.bat
```

**方法2: 手动上传**
```bash
# 压缩数据集
tar -czf Dataset101_HECKTOR2025.tar.gz Dataset101_HECKTOR2025/

# 上传到服务器
scp Dataset101_HECKTOR2025.tar.gz username@server_ip:~/
scp deploy_server.sh username@server_ip:~/
```

### 2. 在服务器上部署

```bash
# 解压数据集
tar -xzf Dataset101_HECKTOR2025.tar.gz

# 运行部署脚本
chmod +x deploy_server.sh
./deploy_server.sh
```

## 📊 数据集信息

- **任务**: 头颈部肿瘤分割
- **模态**: CT
- **训练样本**: 544个
- **标签**: 0=背景, 1=GTVp(原发肿瘤), 2=GTVn(淋巴结)
- **数据集ID**: 101

## 🔧 训练命令

```bash
# 预处理
nnUNetv2_plan_and_preprocess -d 101

# 训练
nnUNetv2_train 101 3d_fullres 0

# 预测
nnUNetv2_predict -i input_folder -o output_folder -d 101 -c 3d_fullres -f 0
```

## 📈 监控训练

```bash
# 查看训练日志
tail -f $nnUNet_results/Dataset101_HECKTOR2025/nnUNetTrainer__nnUNetPlans__3d_fullres/fold_0/training_log_*.txt

# 查看GPU使用
nvidia-smi -l 1
```

## 🎯 预期结果

训练完成后，模型文件将保存在:
```
$nnUNet_results/Dataset101_HECKTOR2025/nnUNetTrainer__nnUNetPlans__3d_fullres/fold_0/
├── checkpoint_best.pth
├── checkpoint_final.pth
└── training_log_*.txt
```

## 🚨 注意事项

1. 确保服务器已安装nnU-Net v2
2. 建议使用GPU进行训练
3. 训练时间约24-48小时（取决于硬件）
4. 需要约50GB存储空间

## 📋 完整部署流程

### 本地准备
1. 运行 `python quick_prepare.py` 准备数据集
2. 运行 `upload_to_server.bat` 上传到服务器

### 服务器部署
1. 解压数据集: `tar -xzf Dataset101_HECKTOR2025.tar.gz`
2. 设置权限: `chmod +x deploy_server.sh`
3. 运行部署: `./deploy_server.sh`

### 环境要求
- Python 3.8+
- PyTorch 1.9+
- nnU-Net v2
- CUDA (推荐)

## 🔍 故障排除

### 常见问题
1. **内存不足**: 减少batch size
2. **GPU显存不足**: 使用混合精度训练
3. **数据集验证失败**: 检查数据完整性

### 性能优化
1. 使用SSD存储
2. 增加系统内存
3. 使用多GPU训练
4. 启用数据压缩 