@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Running Experiment 7: Data Visualization
echo ===========================================

echo.
echo [INFO] Executing data_visualization.py to generate plots...
python data_visualization.py

echo.
echo [INFO] Experiment completed! The output plots are available in the 'output_plots' directory.
pause
