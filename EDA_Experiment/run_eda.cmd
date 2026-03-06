@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Running Experiment 9: EDA Pipeline
echo ===========================================

echo.
echo [INFO] Executing eda_script.py...
python eda_script.py

echo.
echo [INFO] Script completed! Please check terminal output above and the generated maps in '\output_plots\'.
pause
