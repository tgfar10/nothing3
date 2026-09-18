@echo off
setlocal enabledelayedexpansion
title Automation Runner

:: Public Desktop ডিরেক্টরি
if exist "C:\Users\Public\Desktop\bundle_extracted" (
    cd /d "C:\Users\Public\Desktop\bundle_extracted"
) else (
    cd /d "%~dp0bundle_extracted"
)

echo ===================================================
echo Installing requirements...
echo ===================================================
if exist "requirements.txt" (
    pip install -r requirements.txt
) else (
    echo [INFO] requirements.txt not found.
)

echo.
echo ===================================================
echo Starting run_session.py...
echo ===================================================
if exist "run_session.py" (
    python run_session.py
) else (
    echo [ERROR] run_session.py not found in %CD%.
)

echo.
pause
