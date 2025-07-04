# 简化版PT文件删除脚本
# 删除所有患者文件夹中的PT文件

Write-Host "删除HECKTOR2025训练集PT文件..." -ForegroundColor Green

# 获取所有患者文件夹并删除其中的PT文件
Get-ChildItem -Directory | Where-Object { $_.Name -match "^(CHUM|CHUP|CHUS|MDA|USZ)-\d+" } | ForEach-Object {
    $ptFiles = Get-ChildItem -Path $_.FullName -Filter "*__PT.nii.gz"
    if ($ptFiles) {
        $ptFiles | Remove-Item -Force
        Write-Host "已删除 $($_.Name) 中的PT文件" -ForegroundColor Yellow
    }
}

Write-Host "删除完成!" -ForegroundColor Green 