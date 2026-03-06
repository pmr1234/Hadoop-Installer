@echo off
setlocal enabledelayedexpansion

set "DRIVE=%~d0"
set "MONGO_DEST=%DRIVE%\"
set "MONGO_DIR=%DRIVE%\mongodb-win32-x86_64-windows-7.0.14"
set "MONGO_ZIP=mongodb-windows-x86_64-7.0.14.zip"

echo ==============================================================
echo       Automated MongoDB 7.0.14 Portable Installer (Windows)
echo ==============================================================

echo.
echo [1/3] Downloading MongoDB 7.0 Archive...
if not exist "%MONGO_DEST%%MONGO_ZIP%" (
    curl.exe -L -o "%MONGO_DEST%%MONGO_ZIP%" "https://fastdl.mongodb.org/windows/%MONGO_ZIP%"
) else (
    echo Archive already downloaded!
)

echo.
echo [2/3] Extracting Archive...
if not exist "%MONGO_DIR%" (
    powershell -Command "Expand-Archive -Path '%MONGO_DEST%%MONGO_ZIP%' -DestinationPath '%MONGO_DEST%' -Force"
) else (
    echo MongoDB already extracted!
)

echo.
echo [3/3] Creating MongoDB Data Directory...
if not exist "%DRIVE%\mongodb-data" (
    mkdir "%DRIVE%\mongodb-data"
)

echo.
echo MongoDB setup complete! Location: %MONGO_DIR%
echo Data folder created at: %DRIVE%\mongodb-data
echo ==============================================================
pause
