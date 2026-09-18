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
echo Starting one.py manually...
echo ===================================================
if exist "one.py" (
    python one.py
) else (
    echo [ERROR] one.py not found in %CD%.
)

echo.
pause
