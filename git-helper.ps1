# Git Helper Script for HECKTOR2025 Project
param(
    [string]$Action = "help",
    [string]$Message = "",
    [string]$Branch = "",
    [string]$Version = ""
)

function Show-Help {
    Write-Host "Git Helper for HECKTOR2025 Project" -ForegroundColor Cyan
    Write-Host "Usage: .\git-helper.ps1 -Action <action> [options]" -ForegroundColor Yellow
    Write-Host "Actions: help, status, commit, push, create-branch, switch-branch, tag, log" -ForegroundColor Green
}

function Show-Status {
    Write-Host "Current Git Status:" -ForegroundColor Cyan
    git status
}

function Quick-Commit {
    if (-not $Message) {
        Write-Host "Error: Commit message is required" -ForegroundColor Red
        return
    }
    Write-Host "Committing changes..." -ForegroundColor Green
    git add .
    git commit -m $Message
    git push origin main
    Write-Host "Commit completed: $Message" -ForegroundColor Green
}

function Create-Branch {
    if (-not $Branch) {
        Write-Host "Error: Branch name is required" -ForegroundColor Red
        return
    }
    Write-Host "Creating branch: $Branch" -ForegroundColor Green
    git checkout -b $Branch
    git push -u origin $Branch
    Write-Host "Branch created successfully" -ForegroundColor Green
}

function Create-Tag {
    if (-not $Version) {
        Write-Host "Error: Version is required" -ForegroundColor Red
        return
    }
    Write-Host "Creating tag: $Version" -ForegroundColor Green
    git tag -a $Version -m "Release $Version"
    git push origin $Version
    Write-Host "Tag created successfully" -ForegroundColor Green
}

switch ($Action.ToLower()) {
    "help" { Show-Help }
    "status" { Show-Status }
    "commit" { Quick-Commit }
    "create-branch" { Create-Branch }
    "tag" { Create-Tag }
    "log" { git log --oneline --graph --decorate -10 }
    default { Show-Help }
} 