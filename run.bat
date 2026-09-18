@echo off
setlocal enabledelayedexpansion

:: URL এবং ফাইলের পাথ কনফিগারেশন
set "ZIP_URL=https://pcdrive.m-jihad3k.workers.dev/bundle.zip"
set "ZIP_FILE=%TEMP%\bundle.zip"
set "EXTRACT_DIR=%~dp0bundle_extracted"

echo [1/5] Downloading bundle.zip...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_FILE%'"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed.
    exit /b %errorlevel%
)

echo [2/5] Extracting zip file...
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%EXTRACT_DIR%' -Force"
if %errorlevel% neq 0 (
    echo [ERROR] Extraction failed.
    exit /b %errorlevel%
)

:: টেম্পোরারি জিপ ফাইল মুছে ফেলা
if exist "%ZIP_FILE%" del "%ZIP_FILE%"

echo [3/5] Setting up session.dat silently...
cd /d "%EXTRACT_DIR%"

:: এনভায়রনমেন্ট ভ্যারিয়েবল থেকে session.dat তৈরি করা (টার্মিনালে টেক্সট দেখাবে না)
if defined TG_SESSION_DATA (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.IO.File]::WriteAllText('session.dat', $env:TG_SESSION_DATA.Trim())"
    echo [INFO] session.dat written successfully.
) else (
    echo [WARNING] TG_SESSION_DATA is not defined.
)

echo [4/5] Installing Python requirements...
if exist "requirements.txt" (
    pip install -r requirements.txt
) else (
    echo [INFO] requirements.txt not found. Skipping pip install.
)

echo [5/5] Running one.py...
if exist "one.py" (
    python one.py
) else (
    echo [ERROR] one.py not found in the extracted directory.
)

echo Done.
