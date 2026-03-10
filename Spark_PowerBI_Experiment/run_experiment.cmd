@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Bootstrapping PySpark Power BI Pipeline
echo ===========================================

echo.
echo [1/3] Synthesizing Mock NYC Taxi Dataset...
python generate_dataset.py

echo.
echo [2/3] Constructing PySpark Application Dependencies...
python generate_jupyter.py

echo.
echo [3/3] Executing Headless Big Data Pipeline...
python run_pipeline.py

echo.
echo ==============================================================
echo [READY] Open Power BI Desktop and import C:/temp/daily_avg_fare.csv!
echo ==============================================================
pause
