# HECKTOR2025 版本发布脚本
# 自动化版本发布流程

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    [string]$ReleaseNotes = "",
    [switch]$DryRun = $false
)

function Write-Step {
    param([string]$Message)
    Write-Host "🚀 $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Test-Version {
    param([string]$Version)
    if ($Version -notmatch '^v?\d+\.\d+\.\d+(-\w+(\.\d+)?)?$') {
        Write-Error "版本号格式错误。正确格式: v1.0.0 或 v1.0.0-beta.1"
        return $false
    }
    return $true
}

function Get-CurrentBranch {
    return git branch --show-current
}

function Test-GitStatus {
    $status = git status --porcelain
    if ($status) {
        Write-Error "工作区有未提交的更改，请先提交或储藏"
        return $false
    }
    return $true
}

function Test-TagExists {
    param([string]$Tag)
    $existingTag = git tag -l $Tag
    if ($existingTag) {
        Write-Error "标签 '$Tag' 已存在"
        return $true
    }
    return $false
}

function Update-Version {
    param([string]$Version)
    
    # 更新版本信息文件（如果存在）
    $versionFiles = @(
        "version.txt",
        "VERSION",
        "setup.py",
        "pyproject.toml",
        "package.json"
    )
    
    foreach ($file in $versionFiles) {
        if (Test-Path $file) {
            Write-Step "更新 $file 中的版本信息"
            # 这里可以根据具体的文件格式来更新版本号
            # 示例：更新 version.txt
            if ($file -eq "version.txt") {
                $Version | Out-File -FilePath $file -Encoding utf8
                Write-Success "已更新 $file"
            }
        }
    }
}

function Create-ReleaseNotes {
    param([string]$Version, [string]$Notes)
    
    $releaseFile = "RELEASE_NOTES.md"
    $date = Get-Date -Format "yyyy-MM-dd"
    
    if (-not $Notes) {
        # 从git日志生成发布说明
        $lastTag = git describe --tags --abbrev=0 2>$null
        if ($lastTag) {
            $commits = git log --oneline "$lastTag..HEAD"
        } else {
            $commits = git log --oneline
        }
        
        $Notes = "## 变更内容`n`n"
        $commits | ForEach-Object {
            $Notes += "- $_`n"
        }
    }
    
    $releaseContent = @"
# $Version ($date)

$Notes

"@
    
    # 如果发布说明文件存在，则追加到开头
    if (Test-Path $releaseFile) {
        $existingContent = Get-Content $releaseFile -Raw
        $releaseContent += $existingContent
    }
    
    $releaseContent | Out-File -FilePath $releaseFile -Encoding utf8
    Write-Success "已更新发布说明文件"
}

function Main {
    Write-Host "=== HECKTOR2025 版本发布工具 ===" -ForegroundColor Magenta
    Write-Host ""
    
    # 验证版本号格式
    if (-not (Test-Version $Version)) {
        exit 1
    }
    
    # 确保版本号以v开头
    if (-not $Version.StartsWith("v")) {
        $Version = "v$Version"
    }
    
    Write-Step "准备发布版本: $Version"
    
    if ($DryRun) {
        Write-Warning "这是一次试运行，不会实际执行Git操作"
    }
    
    # 检查Git状态
    if (-not (Test-GitStatus)) {
        exit 1
    }
    
    # 检查是否在main分支
    $currentBranch = Get-CurrentBranch
    if ($currentBranch -ne "main") {
        Write-Warning "当前不在main分支 (当前: $currentBranch)"
        $confirm = Read-Host "是否继续? (y/N)"
        if ($confirm -ne "y" -and $confirm -ne "Y") {
            Write-Host "发布已取消"
            exit 0
        }
    }
    
    # 检查标签是否已存在
    if (Test-TagExists $Version) {
        exit 1
    }
    
    # 更新版本信息
    Write-Step "更新版本信息"
    Update-Version $Version
    
    # 创建发布说明
    Write-Step "生成发布说明"
    Create-ReleaseNotes $Version $ReleaseNotes
    
    if (-not $DryRun) {
        # 提交版本更新
        Write-Step "提交版本更新"
        git add .
        git commit -m "chore(release): 发布版本 $Version"
        
        # 创建标签
        Write-Step "创建Git标签"
        if ($ReleaseNotes) {
            git tag -a $Version -m "Release $Version`n`n$ReleaseNotes"
        } else {
            git tag -a $Version -m "Release $Version"
        }
        
        # 推送到远程
        Write-Step "推送到远程仓库"
        git push origin $currentBranch
        git push origin $Version
        
        Write-Success "版本 $Version 发布成功！"
        Write-Host ""
        Write-Host "GitHub发布页面: https://github.com/hhccqu/HECKTOR2025/releases/tag/$Version" -ForegroundColor Blue
    } else {
        Write-Success "试运行完成，实际发布时请移除 -DryRun 参数"
    }
}

# 运行主函数
Main 