# GitHub实时更新脚本
# 用于自动提交和推送更改到GitHub

param(
    [string]$commitMessage = "自动更新: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

Write-Host "开始GitHub实时更新..." -ForegroundColor Green

# 检查是否有更改
$status = git status --porcelain
if ($status) {
    Write-Host "检测到文件更改，正在提交..." -ForegroundColor Yellow
    
    # 添加所有更改的文件
    git add .
    
    # 提交更改
    git commit -m $commitMessage
    
    # 推送到GitHub
    Write-Host "正在推送到GitHub..." -ForegroundColor Yellow
    git push origin main
    
    Write-Host "更新完成！" -ForegroundColor Green
} else {
    Write-Host "没有检测到文件更改。" -ForegroundColor Blue
}

Write-Host "当前仓库状态:" -ForegroundColor Cyan
git status 