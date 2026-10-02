@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ========================================
echo YSC Auto Update Tool - EXE Builder
echo ========================================

where py >nul 2>&1
if not errorlevel 1 goto :PYOK
where python >nul 2>&1
if not errorlevel 1 goto :PYTHONOK

echo [ERROR] Python 3 was not found.
echo Please install Python 3 and enable "Add Python to PATH".
pause
exit /b 1

:PYOK
set "PY=py"
goto :INSTALL

:PYTHONOK
set "PY=python"

:INSTALL
%PY% -m pip install --upgrade pyinstaller
if errorlevel 1 (
  echo [ERROR] Could not install PyInstaller.
  pause
  exit /b 1
)

if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist YSC_AutoUpdate.exe del /q YSC_AutoUpdate.exe

%PY% -m PyInstaller --onefile --console --name YSC_AutoUpdate ^
  --add-data "config.json;." ^
  --add-data "apktool.jar;." ^
  --add-data "apksigner.jar;." ^
  --add-data "ysc-update.jks;." ^
  --add-data "patch;patch" ^
  ysc_auto_update.py

if errorlevel 1 (
  echo [ERROR] EXE build failed.
  pause
  exit /b 1
)

copy /y "dist\YSC_AutoUpdate.exe" ".\YSC_AutoUpdate.exe" >nul
if errorlevel 1 (
  echo [ERROR] Could not copy EXE.
  pause
  exit /b 1
)

rmdir /s /q build 2>nul
rmdir /s /q dist 2>nul

echo.
echo [OK] YSC_AutoUpdate.exe created successfully.
echo.
echo Drag an APK file onto YSC_AutoUpdate.exe to process it.
pause
