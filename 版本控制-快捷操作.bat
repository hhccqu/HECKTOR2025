@echo off
chcp 65001 > nul
title HECKTOR2025 版本控制管理

:menu
cls
echo.
echo ========================================
echo        HECKTOR2025 版本控制管理
echo ========================================
echo.
echo 请选择操作:
echo.
echo 1. 查看当前状态
echo 2. 快速提交更改
echo 3. 创建新分支
echo 4. 切换分支
echo 5. 合并分支
echo 6. 创建版本标签
echo 7. 查看版本历史
echo 8. 推送所有更改
echo 9. 查看帮助
echo 0. 退出
echo.
set /p choice="请输入选项 (0-9): "

if "%choice%"=="1" goto status
if "%choice%"=="2" goto commit
if "%choice%"=="3" goto create_branch
if "%choice%"=="4" goto switch_branch
if "%choice%"=="5" goto merge_branch
if "%choice%"=="6" goto create_tag
if "%choice%"=="7" goto show_log
if "%choice%"=="8" goto push_all
if "%choice%"=="9" goto help
if "%choice%"=="0" goto exit

echo 无效选项，请重新选择
pause
goto menu

:status
echo.
echo 正在查看当前状态...
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action status
pause
goto menu

:commit
echo.
set /p message="请输入提交消息: "
if "%message%"=="" (
    echo 错误: 提交消息不能为空
    pause
    goto menu
)
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action quick-commit -Message "%message%"
pause
goto menu

:create_branch
echo.
set /p branch="请输入新分支名称: "
if "%branch%"=="" (
    echo 错误: 分支名称不能为空
    pause
    goto menu
)
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action create-branch -BranchName "%branch%"
pause
goto menu

:switch_branch
echo.
set /p branch="请输入要切换的分支名称: "
if "%branch%"=="" (
    echo 错误: 分支名称不能为空
    pause
    goto menu
)
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action switch-branch -BranchName "%branch%"
pause
goto menu

:merge_branch
echo.
set /p branch="请输入要合并的分支名称: "
if "%branch%"=="" (
    echo 错误: 分支名称不能为空
    pause
    goto menu
)
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action merge-branch -BranchName "%branch%"
pause
goto menu

:create_tag
echo.
set /p version="请输入版本号 (例: v1.0.0): "
if "%version%"=="" (
    echo 错误: 版本号不能为空
    pause
    goto menu
)
set /p tag_message="请输入版本描述 (可选): "
if "%tag_message%"=="" (
    powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action create-tag -Version "%version%"
) else (
    powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action create-tag -Version "%version%" -Message "%tag_message%"
)
pause
goto menu

:show_log
echo.
echo 正在查看提交历史...
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action show-log
pause
goto menu

:push_all
echo.
echo 正在推送所有更改...
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action push-all
pause
goto menu

:help
echo.
echo 正在显示帮助信息...
powershell -ExecutionPolicy Bypass -File "版本控制管理.ps1" -Action help
pause
goto menu

:exit
echo.
echo 感谢使用 HECKTOR2025 版本控制管理工具！
pause
exit 