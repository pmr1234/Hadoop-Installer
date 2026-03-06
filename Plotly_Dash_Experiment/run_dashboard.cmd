@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Running Experiment 8: Plotly and Dash
echo ===========================================

echo.
echo [INFO] Booting up the local Flask Web Server...
echo [INFO] Please open your browser and go to:
echo        http://127.0.0.1:8050/
echo.
echo [INFO] Press Ctrl+C in this terminal when you want to stop the server!
echo ===========================================
echo.

python interactive_dashboard.py
pause
