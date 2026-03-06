@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Running PySpark + MongoDB Experiment 6
echo ===========================================

set "DRIVE=%~d0"
set "MONGO_DIR=%DRIVE%\mongodb-win32-x86_64-windows-7.0.14"
set "MONGO_DATA=%DRIVE%\mongodb-data"

if not exist "%MONGO_DIR%\bin\mongod.exe" (
    echo [ERROR] MongoDB not found! Please run auto_install_mongo.cmd first.
    pause
    exit /b 1
)

:: Ensure JAVA_HOME is configured explicitly as Spark requires it
if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
)
set "PATH=%JAVA_HOME%\bin;%MONGO_DIR%\bin;%PATH%"

if not defined HADOOP_HOME (
    set "HADOOP_HOME=%DRIVE%\hadoop-3.4.2\hadoop-3.4.2"
)

echo [INFO] Starting MongoDB Server automatically...
start "MongoDB Backend" /MIN "%MONGO_DIR%\bin\mongod.exe" --dbpath "%MONGO_DATA%"

:: Wait a few seconds for mongod to boot up
timeout /t 5 >nul

echo [INFO] Running PySpark Integration Script...
python spark_mongo.py

echo.
echo ===========================================
echo   Cleaning up MongoDB Server...
echo ===========================================
taskkill /F /IM mongod.exe >nul 2>&1

echo Experiment Finished successfully!
pause
