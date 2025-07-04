@echo off
echo ========================================
echo HECKTOR2025 数据集上传脚本
echo ========================================

echo 请输入服务器信息:
set /p SERVER_IP=服务器IP地址: 
set /p USERNAME=用户名: 

echo 压缩数据集...
tar -czf Dataset101_HECKTOR2025.tar.gz Dataset101_HECKTOR2025/

echo 上传到服务器...
scp Dataset101_HECKTOR2025.tar.gz %USERNAME%@%SERVER_IP%:~/
scp deploy_server.sh %USERNAME%@%SERVER_IP%:~/

echo 上传完成！
echo.
echo 在服务器上运行以下命令:
echo   tar -xzf Dataset101_HECKTOR2025.tar.gz
echo   chmod +x deploy_server.sh
echo   ./deploy_server.sh
echo.
echo 或者使用以下命令连接到服务器:
echo   ssh %USERNAME%@%SERVER_IP%

pause 