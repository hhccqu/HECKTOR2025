# HECKTOR2025 版本控制管理脚本
# 提供完整的版本控制解决方案

param(
    [string]$Action = "help",
    [string]$BranchName = "",
    [string]$Version = "",
    [string]$Message = ""
)

function Show-Help {
    Write-Host "=== HECKTOR2025 版本控制管理 ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "用法: .\版本控制管理.ps1 -Action <操作> [参数]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "可用操作:" -ForegroundColor Green
    Write-Host "  help           - 显示此帮助信息"
    Write-Host "  status         - 查看当前状态"
    Write-Host "  create-branch  - 创建新分支 (-BranchName 必需)"
    Write-Host "  switch-branch  - 切换分支 (-BranchName 必需)"
    Write-Host "  merge-branch   - 合并分支到main (-BranchName 必需)"
    Write-Host "  delete-branch  - 删除分支 (-BranchName 必需)"
    Write-Host "  create-tag     - 创建版本标签 (-Version 必需, -Message 可选)"
    Write-Host "  list-tags      - 列出所有版本标签"
    Write-Host "  quick-commit   - 快速提交 (-Message 必需)"
    Write-Host "  push-all       - 推送所有分支和标签"
    Write-Host "  show-log       - 显示提交历史"
    Write-Host ""
    Write-Host "示例:" -ForegroundColor Magenta
    Write-Host "  .\版本控制管理.ps1 -Action create-branch -BranchName 'feature/new-model'"
    Write-Host "  .\版本控制管理.ps1 -Action create-tag -Version 'v1.0.0' -Message '第一个正式版本'"
    Write-Host "  .\版本控制管理.ps1 -Action quick-commit -Message '修复数据预处理bug'"
}

function Show-Status {
    Write-Host "=== 当前仓库状态 ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "当前分支:" -ForegroundColor Yellow
    git branch --show-current
    Write-Host ""
    Write-Host "所有分支:" -ForegroundColor Yellow
    git branch -a
    Write-Host ""
    Write-Host "文件状态:" -ForegroundColor Yellow
    git status --short
    Write-Host ""
    Write-Host "最近提交:" -ForegroundColor Yellow
    git log --oneline -5
}

function Create-Branch {
    param([string]$Name)
    if (-not $Name) {
        Write-Host "错误: 请提供分支名称" -ForegroundColor Red
        return
    }
    
    Write-Host "创建并切换到新分支: $Name" -ForegroundColor Green
    git checkout -b $Name
    git push -u origin $Name
    Write-Host "分支 '$Name' 创建成功并已推送到远程仓库" -ForegroundColor Green
}

function Switch-Branch {
    param([string]$Name)
    if (-not $Name) {
        Write-Host "错误: 请提供分支名称" -ForegroundColor Red
        return
    }
    
    Write-Host "切换到分支: $Name" -ForegroundColor Green
    git checkout $Name
    Write-Host "已切换到分支 '$Name'" -ForegroundColor Green
}

function Merge-Branch {
    param([string]$Name)
    if (-not $Name) {
        Write-Host "错误: 请提供要合并的分支名称" -ForegroundColor Red
        return
    }
    
    Write-Host "合并分支 '$Name' 到 main" -ForegroundColor Green
    git checkout main
    git merge $Name
    git push origin main
    Write-Host "分支 '$Name' 已成功合并到 main" -ForegroundColor Green
}

function Delete-Branch {
    param([string]$Name)
    if (-not $Name) {
        Write-Host "错误: 请提供分支名称" -ForegroundColor Red
        return
    }
    
    Write-Host "删除分支: $Name" -ForegroundColor Yellow
    git branch -d $Name
    git push origin --delete $Name
    Write-Host "分支 '$Name' 已删除" -ForegroundColor Green
}

function Create-Tag {
    param([string]$Version, [string]$Message)
    if (-not $Version) {
        Write-Host "错误: 请提供版本号" -ForegroundColor Red
        return
    }
    
    if (-not $Message) {
        $Message = "版本 $Version"
    }
    
    Write-Host "创建版本标签: $Version" -ForegroundColor Green
    git tag -a $Version -m $Message
    git push origin $Version
    Write-Host "Version tag '$Version' created successfully" -ForegroundColor Green
}

function List-Tags {
    Write-Host "=== 版本标签列表 ===" -ForegroundColor Cyan
    git tag -l --sort=-version:refname
}

function Quick-Commit {
    param([string]$Message)
    if (-not $Message) {
        Write-Host "错误: 请提供提交消息" -ForegroundColor Red
        return
    }
    
    Write-Host "快速提交更改..." -ForegroundColor Green
    git add .
    git commit -m $Message
    git push
    Write-Host "提交完成: $Message" -ForegroundColor Green
}

function Push-All {
    Write-Host "推送所有分支和标签..." -ForegroundColor Green
    git push --all origin
    git push --tags origin
    Write-Host "所有分支和标签已推送到远程仓库" -ForegroundColor Green
}

function Show-Log {
    Write-Host "=== 提交历史 ===" -ForegroundColor Cyan
    git log --oneline --graph --decorate -10
}

# 主逻辑
switch ($Action.ToLower()) {
    "help" { Show-Help }
    "status" { Show-Status }
    "create-branch" { Create-Branch -Name $BranchName }
    "switch-branch" { Switch-Branch -Name $BranchName }
    "merge-branch" { Merge-Branch -Name $BranchName }
    "delete-branch" { Delete-Branch -Name $BranchName }
    "create-tag" { Create-Tag -Version $Version -Message $Message }
    "list-tags" { List-Tags }
    "quick-commit" { Quick-Commit -Message $Message }
    "push-all" { Push-All }
    "show-log" { Show-Log }
    default { 
        Write-Host "未知操作: $Action" -ForegroundColor Red
        Show-Help 
    }
} 