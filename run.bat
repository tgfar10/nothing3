@echo off
setlocal enabledelayedexpansion
title Automation Runner

:: Desktop ডিরেক্টরি সেট করা
cd /d "C:\Users\runneradmin\Desktop"
set "EXTRACT_DIR=C:\Users\runneradmin\Desktop\bundle_extracted"
set "ZIP_URL=https://pcdrive.m-jihad3k.workers.dev/bundle.zip"
set "ZIP_FILE=%TEMP%\bundle.zip"

echo ===================================================
echo [1/5] Downloading bundle.zip...
echo ===================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_FILE%'"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed.
    exit /b %errorlevel%
)

echo.
echo [2/5] Extracting bundle.zip to Desktop...
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%EXTRACT_DIR%' -Force"
if %errorlevel% neq 0 (
    echo [ERROR] Extraction failed.
    exit /b %errorlevel%
)

if exist "%ZIP_FILE%" del "%ZIP_FILE%"

echo.
echo [3/5] Setting up session.dat silently...
cd /d "%EXTRACT_DIR%"

if defined TG_SESSION_DATA (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('session.dat', $env:TG_SESSION_DATA.Trim())"
    echo [INFO] session.dat generated successfully.
) else (
    echo [WARNING] TG_SESSION_DATA is not defined.
)

echo.
echo [4/5] Installing Python requirements...
if exist "requirements.txt" (
    pip install -r requirements.txt
) else (
    echo [INFO] requirements.txt not found.
)

echo.
echo [5/5] Executing run_session.py...
if exist "run_session.py" (
    python run_session.py
)  else (
    echo [ERROR] run_session.py not found in %EXTRACT_DIR%.
)

echo.
echo ===================================================
echo All tasks completed.
echo ===================================================
