# HECKTOR2025 nnU-Net 数据集准备与训练指南

## 📋 项目概述

本项目将HECKTOR2025 Task 1数据集转换为nnU-Net v2格式，用于头颈部肿瘤分割任务。

### 🎯 任务目标
- **分割目标**: GTVp (原发肿瘤) + GTVn (淋巴结) + 正常区域
- **输入模态**: CT影像
- **标签值**: 0=背景, 1=GTVp, 2=GTVn
- **数据量**: 680个病例，来自7个医疗中心

### 🏥 数据来源
- **CHUM**: 加拿大蒙特利尔大学医院
- **CHUP**: 巴黎皮埃尔居里医院  
- **CHUS**: 加拿大谢尔布鲁克大学医院
- **MDA**: 德州大学MD安德森癌症中心
- **USZ**: 苏黎世大学医院
- **HGJ**: 55个病例
- **HMR**: 18个病例

## 🚀 快速开始

### 步骤1: 本地数据准备 (Windows)

1. **检查数据结构**
   ```
   HECKTOR2025 Task 1 Training/Task 1/
   ├── 患者ID文件夹/
   │   ├── 患者ID.nii.gz          # 分割标注
   │   └── 患者ID__CT.nii.gz      # CT影像
   ├── HECKTOR_2025_Training_Task_1.csv
   └── ...
   ```

2. **运行数据准备脚本**
   ```bash
   # 方法1: 使用批处理脚本
   run_preparation.bat
   
   # 方法2: 手动运行
   pip install -r requirements.txt
   python prepare_nnunet_dataset.py --source_dir . --output_dir ./nnUNet_raw --dataset_id 101
   ```

3. **验证输出结果**
   ```
   nnUNet_raw/Dataset101_HECKTOR2025/
   ├── dataset.json
   ├── splits_final.json
   ├── README.md
   ├── imagesTr/
   │   ├── HECKTOR_0001_0000.nii.gz
   │   ├── HECKTOR_0002_0000.nii.gz
   │   └── ... (544个文件, 80%训练集)
   └── labelsTr/
       ├── HECKTOR_0001.nii.gz
       ├── HECKTOR_0002.nii.gz
       └── ... (544个文件)
   ```

### 步骤2: 上传到服务器

1. **压缩数据集**
   ```bash
   # 压缩Dataset101_HECKTOR2025文件夹
   tar -czf Dataset101_HECKTOR2025.tar.gz nnUNet_raw/Dataset101_HECKTOR2025/
   ```

2. **上传到阿里云服务器**
   ```bash
   # 使用scp上传
   scp Dataset101_HECKTOR2025.tar.gz username@server_ip:~/
   
   # 或使用rsync
   rsync -avz Dataset101_HECKTOR2025.tar.gz username@server_ip:~/
   ```

### 步骤3: 服务器端部署

1. **解压数据集**
   ```bash
   cd ~
   tar -xzf Dataset101_HECKTOR2025.tar.gz
   ```

2. **设置nnU-Net环境**
   ```bash
   # 设置环境变量
   export nnUNet_raw="$HOME/nnUNet_raw"
   export nnUNet_preprocessed="$HOME/nnUNet_preprocessed"  
   export nnUNet_results="$HOME/nnUNet_results"
   
   # 将环境变量添加到bashrc
   echo 'export nnUNet_raw="$HOME/nnUNet_raw"' >> ~/.bashrc
   echo 'export nnUNet_preprocessed="$HOME/nnUNet_preprocessed"' >> ~/.bashrc
   echo 'export nnUNet_results="$HOME/nnUNet_results"' >> ~/.bashrc
   ```

3. **运行部署脚本**
   ```bash
   chmod +x deploy_to_server.sh
   ./deploy_to_server.sh
   ```

   或手动执行：
   ```bash
   # 预处理
   nnUNetv2_plan_and_preprocess -d 101 --verify_dataset_integrity
   
   # 开始训练
   nnUNetv2_train 101 3d_fullres 0
   ```

## 📊 数据集详细信息

### 文件命名规则
- **图像文件**: `HECKTOR_XXXX_0000.nii.gz` (XXXX为4位数字)
- **标签文件**: `HECKTOR_XXXX.nii.gz`
- **模态编号**: 0000 = CT

### 标签定义
```json
{
  "labels": {
    "background": 0,
    "GTVp": 1,       // 原发肿瘤 (Gross Tumor Volume primary)
    "GTVn": 2        // 淋巴结 (Gross Tumor Volume nodal)
  }
}
```

### 数据分割
- **训练集**: 80% (544个病例)
- **验证集**: 20% (136个病例)
- **交叉验证**: 5折

## 🔧 脚本参数说明

### prepare_nnunet_dataset.py 参数
```bash
python prepare_nnunet_dataset.py \
  --source_dir .                    # 原始数据目录
  --output_dir ./nnUNet_raw         # 输出目录
  --dataset_id 101                  # 数据集ID
  --train_split 0.8                 # 训练集比例
```

### nnU-Net 训练参数
```bash
# 基础训练
nnUNetv2_train 101 3d_fullres 0

# 多GPU训练
nnUNetv2_train 101 3d_fullres 0 --npz  # 使用npz格式加速

# 继续训练
nnUNetv2_train 101 3d_fullres 0 -c
```

## 📈 训练监控

### 查看训练进度
```bash
# 查看训练日志
tail -f $nnUNet_results/Dataset101_HECKTOR2025/nnUNetTrainer__nnUNetPlans__3d_fullres/fold_0/training_log_*.txt

# 查看GPU使用情况
nvidia-smi -l 1
```

### 训练结果位置
```
$nnUNet_results/Dataset101_HECKTOR2025/nnUNetTrainer__nnUNetPlans__3d_fullres/fold_0/
├── checkpoint_best.pth          # 最佳模型
├── checkpoint_final.pth         # 最终模型
├── training_log_*.txt           # 训练日志
├── validation_raw/              # 验证结果
└── plans.json                   # 训练计划
```

## 🔍 验证与测试

### 验证模型性能
```bash
# 验证单个fold
nnUNetv2_predict -i $nnUNet_raw/Dataset101_HECKTOR2025/imagesTs \
                 -o ./predictions \
                 -d 101 -c 3d_fullres -f 0

# 5折交叉验证
nnUNetv2_predict -i $nnUNet_raw/Dataset101_HECKTOR2025/imagesTs \
                 -o ./predictions \
                 -d 101 -c 3d_fullres -f 0 1 2 3 4
```

### 计算评估指标
```bash
# 计算Dice系数等指标
nnUNetv2_evaluate_folder -ref ./ground_truth \
                         -pred ./predictions \
                         -l 1 2  # 评估标签1和2
```

## 🚨 故障排除

### 常见问题

1. **内存不足**
   ```bash
   # 减少batch size
   export nnUNet_batch_size=2
   ```

2. **GPU显存不足**
   ```bash
   # 使用混合精度训练
   nnUNetv2_train 101 3d_fullres 0 --use_compressed_data
   ```

3. **数据集验证失败**
   ```bash
   # 检查数据完整性
   python -c "
   import nibabel as nib
   import os
   for f in os.listdir('imagesTr'):
       try:
           nib.load(f'imagesTr/{f}')
       except:
           print(f'损坏文件: {f}')
   "
   ```

### 性能优化建议

1. **使用SSD存储**
2. **增加系统内存**
3. **使用多GPU训练**
4. **启用数据压缩**

## 📞 技术支持

### 相关资源
- [nnU-Net官方文档](https://github.com/MIC-DKFZ/nnUNet)
- [HECKTOR Challenge](https://www.aicrowd.com/challenges/hecktor-2025)
- [医学图像分割最佳实践](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/how_to_use_nnunet.md)

### 联系方式
如有问题，请检查：
1. 数据集格式是否正确
2. nnU-Net环境是否正确安装
3. 系统资源是否充足

---

**注意**: 训练大型3D医学图像分割模型需要大量计算资源，建议使用GPU加速训练。 