# HECKTOR2025 项目

这是一个用于HECKTOR2025挑战赛的医学图像分析项目。

## 项目结构

- `nnUNet/` - nnUNet框架代码
- `swin_unetr_hecktor_2022-main/` - Swin-UNETR模型代码
- `HECKTOR2025_deployment/` - 部署相关脚本
- `delete_pt_files*.ps1` - 清理脚本

## 版本控制管理

### 🚀 快速开始
1. **简单更新**: 双击运行 `快速更新GitHub.bat`
2. **完整管理**: 双击运行 `版本控制-快捷操作.bat`
3. **命令行**: 使用 `版本控制管理.ps1` 脚本

### 📋 版本控制工具

#### 1. 快速更新（推荐新手）
```batch
# 双击运行
快速更新GitHub.bat
```

#### 2. 完整版本控制管理
```batch
# 双击运行，提供交互式菜单
版本控制-快捷操作.bat
```

#### 3. PowerShell脚本（推荐开发者）
```powershell
# 查看帮助
.\版本控制管理.ps1 -Action help

# 查看当前状态
.\版本控制管理.ps1 -Action status

# 快速提交
.\版本控制管理.ps1 -Action quick-commit -Message "添加新功能"

# 创建新分支
.\版本控制管理.ps1 -Action create-branch -BranchName "feature/new-model"

# 创建版本标签
.\版本控制管理.ps1 -Action create-tag -Version "v1.0.0" -Message "第一个正式版本"
```

#### 4. 版本发布
```powershell
# 试运行（预览操作）
.\版本发布.ps1 -Version "1.0.0" -DryRun

# 正式发布
.\版本发布.ps1 -Version "1.0.0" -ReleaseNotes "添加Swin-UNETR模型支持"
```

### 📝 提交规范
项目使用规范化的提交消息格式：
```
<类型>(<范围>): <描述>

详细说明...
```

**提交类型**：
- `feat`: 新功能
- `fix`: 修复bug  
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构代码
- `test`: 测试相关
- `chore`: 其他更改

**示例**：
```bash
feat(model): 添加Swin-UNETR模型训练功能
fix(data): 修复数据预处理中的内存泄漏问题
docs(readme): 更新安装说明文档
```

### 🌿 分支管理策略
- **main**: 主分支，稳定发布版本
- **develop**: 开发分支，集成新功能
- **feature/***: 功能分支，开发新功能
- **hotfix/***: 热修复分支，紧急修复
- **release/***: 发布分支，准备发布

### 🏷️ 版本标签
采用语义化版本控制（SemVer）：
```
v主版本号.次版本号.修订号
```

示例：
- `v1.0.0` - 第一个正式版本
- `v1.1.0` - 添加新功能
- `v1.1.1` - 修复bug

## 实时更新流程

1. **修改代码**后，使用上述任意方法
2. **自动检测**文件更改
3. **自动提交**到本地仓库
4. **自动推送**到GitHub

## 📁 版本控制文件说明

### 核心脚本文件
- `版本控制管理.ps1` - 完整的版本控制管理脚本
- `版本控制-快捷操作.bat` - 交互式版本控制菜单
- `版本发布.ps1` - 自动化版本发布工具
- `update_github.ps1` - 简单的GitHub更新脚本
- `快速更新GitHub.bat` - 一键更新工具

### 配置文件
- `commit-template.txt` - Git提交消息模板
- `版本控制策略.md` - 详细的版本控制策略文档
- `version.txt` - 当前版本号文件
- `.gitignore` - Git忽略文件配置

### 使用建议
1. **初学者**: 使用 `快速更新GitHub.bat` 进行基本的代码更新
2. **中级用户**: 使用 `版本控制-快捷操作.bat` 获得完整的版本控制体验
3. **高级用户**: 直接使用PowerShell脚本或Git命令行进行精细控制

## 💡 最佳实践

### ✅ 推荐做法
- 频繁提交，每次解决一个问题
- 使用清晰的提交消息
- 为不同功能创建分支
- 定期创建版本标签
- 在发布前进行代码审查

### ❌ 避免做法
- 不要直接在main分支开发
- 不要提交大型数据文件
- 不要使用模糊的提交消息
- 不要忽略版本控制流程

## 📊 项目版本历史

当前版本：v0.1.0

查看完整版本历史：
```bash
git log --oneline --graph --decorate
```

查看所有版本标签：
```bash
git tag -l --sort=-version:refname
```

## 🔗 相关链接

- GitHub仓库：https://github.com/hhccqu/HECKTOR2025.git
- 版本控制策略：[版本控制策略.md](版本控制策略.md)
- 提交规范：[commit-template.txt](commit-template.txt)

## 📞 技术支持

如果您在使用版本控制工具时遇到问题，请：
1. 查看 `版本控制策略.md` 文档
2. 运行 `.\版本控制管理.ps1 -Action help` 获取帮助
3. 在GitHub仓库中提交Issue 