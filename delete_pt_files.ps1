# HECKTOR2025 Task 1 训练集PT文件删除脚本
# 此脚本将删除所有患者文件夹中的PT文件 (*__PT.nii.gz)

Write-Host "开始删除HECKTOR2025 Task 1训练集中的PT文件..." -ForegroundColor Green

# 获取当前目录下所有的患者文件夹
$patientFolders = Get-ChildItem -Directory | Where-Object { $_.Name -match "^(CHUM|CHUP|CHUS|MDA|USZ)-\d+" }

$totalFolders = $patientFolders.Count
$deletedCount = 0
$errorCount = 0

Write-Host "找到 $totalFolders 个患者文件夹" -ForegroundColor Yellow

foreach ($folder in $patientFolders) {
    Write-Host "处理文件夹: $($folder.Name)" -ForegroundColor Cyan
    
    # 查找PT文件
    $ptFiles = Get-ChildItem -Path $folder.FullName -Filter "*__PT.nii.gz"
    
    if ($ptFiles.Count -gt 0) {
        foreach ($ptFile in $ptFiles) {
            try {
                Write-Host "  删除文件: $($ptFile.Name)" -ForegroundColor White
                Remove-Item -Path $ptFile.FullName -Force
                $deletedCount++
            }
            catch {
                Write-Host "  错误: 无法删除 $($ptFile.Name) - $($_.Exception.Message)" -ForegroundColor Red
                $errorCount++
            }
        }
    }
    else {
        Write-Host "  未找到PT文件" -ForegroundColor Gray
    }
}

Write-Host "`n删除完成!" -ForegroundColor Green
Write-Host "统计信息:" -ForegroundColor Yellow
Write-Host "  总文件夹数: $totalFolders" -ForegroundColor White
Write-Host "  成功删除: $deletedCount 个PT文件" -ForegroundColor Green
Write-Host "  删除失败: $errorCount 个文件" -ForegroundColor Red

if ($errorCount -gt 0) {
    Write-Host "`n警告: 有 $errorCount 个文件删除失败，请检查文件权限或文件是否被占用" -ForegroundColor Yellow
}

Write-Host "`n按任意键继续..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 