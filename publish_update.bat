@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
if not exist "update" mkdir "update"
if not exist "update\ysc.apk" (echo [ERROR] 请把 APK 放到 update\ysc.apk&pause&exit /b 1)
if not exist "update\update.json" (echo [ERROR] 缺少 update\update.json&pause&exit /b 1)
git add update\ysc.apk update\update.json
git commit -m "Publish YSC update"
if errorlevel 1 (echo [ERROR] Git commit 失败&pause&exit /b 1)
git push origin main
if errorlevel 1 (echo [ERROR] GitHub 上传失败&pause&exit /b 1)
echo 发布完成
pause
