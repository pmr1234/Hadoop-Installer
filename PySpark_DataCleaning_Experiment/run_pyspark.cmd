@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Running PySpark Data Cleaning Experiment
echo ===========================================

:: Ensure JAVA_HOME is configured explicitly as Spark requires it
if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
)
set "PATH=%JAVA_HOME%\bin;%PATH%"

set "DRIVE=%~d0"
if not defined HADOOP_HOME (
    set "HADOOP_HOME=%DRIVE%\hadoop-3.4.2\hadoop-3.4.2"
)

echo [INFO] Using JAVA_HOME: %JAVA_HOME%
echo [INFO] Using HADOOP_HOME: %HADOOP_HOME%
echo.

python data_cleaning.py

echo.
echo ===========================================
echo   Experiment Finished.
echo ===========================================
pause
