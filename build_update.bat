@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if "%~1"=="" (
  echo Drag an APK file onto this BAT file.
  pause
  exit /b 1
)

where py >nul 2>&1
if not errorlevel 1 goto :RUNPY
where python >nul 2>&1
if not errorlevel 1 goto :RUNPYTHON

echo [ERROR] Python 3 was not found.
echo Please install Python 3 and enable "Add Python to PATH".
pause
exit /b 1

:RUNPY
py ysc_auto_update.py "%~1"
goto :END

:RUNPYTHON
python ysc_auto_update.py "%~1"

:END
pause
