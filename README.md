# HECKTOR2025 项目

这是一个用于HECKTOR2025挑战赛的医学图像分析项目。

## 项目结构

- `nnUNet/` - nnUNet框架代码
- `swin_unetr_hecktor_2022-main/` - Swin-UNETR模型代码
- `HECKTOR2025_deployment/` - 部署相关脚本
- `delete_pt_files*.ps1` - 清理脚本

## GitHub更新方法

### 方法1：使用批处理文件（推荐）
双击运行 `快速更新GitHub.bat` 文件即可自动更新GitHub仓库。

### 方法2：使用PowerShell脚本
```powershell
# 使用默认提交消息
.\update_github.ps1

# 使用自定义提交消息
.\update_github.ps1 -commitMessage "添加新功能"
```

### 方法3：手动Git命令
```bash
# 添加所有更改的文件
git add .

# 提交更改
git commit -m "描述您的更改"

# 推送到GitHub
git push origin main
```

## 实时更新流程

1. **修改代码**后，使用上述任意方法
2. **自动检测**文件更改
3. **自动提交**到本地仓库
4. **自动推送**到GitHub

## 注意事项

- 大型数据文件已通过`.gitignore`排除
- 每次更新都会自动生成时间戳
- 如果没有文件更改，不会执行提交操作

## 仓库地址

GitHub仓库：https://github.com/hhccqu/HECKTOR2025.git 