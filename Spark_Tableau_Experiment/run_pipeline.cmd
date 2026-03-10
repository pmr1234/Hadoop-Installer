@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Bootstrapping Spark/Tableau Pipeline
echo ===========================================

echo.
echo [INFO] Handing off orchestration to Python subprocess daemon...
python orchestrate_spark_stream.py

pause
