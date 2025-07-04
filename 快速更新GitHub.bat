@echo off
chcp 65001 > nul
echo 正在更新GitHub仓库...
powershell -ExecutionPolicy Bypass -File "update_github.ps1"
pause 