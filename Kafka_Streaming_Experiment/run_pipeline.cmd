@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

call auto_install_kafka.cmd

echo.
echo [INFO] Handing off orchestration to Python subprocess daemon...
python orchestrate_pipeline.py

pause
