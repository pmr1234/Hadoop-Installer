@echo off
setlocal
cls

echo =======================================================
echo          [EXPERIMENT 5] PySpark MLlib Analytics
echo =======================================================
echo.

:: 1. Verify Java
java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java is not installed or not in PATH.
    echo Please ensure Java 8 is installed and JAVA_HOME is set.
    pause
    exit /b 1
)

:: 2. Verify Python
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python is not installed or not in PATH.
    pause
    exit /b 1
)

:: 3. Execute PySpark Classification Job
echo [1/2] Invoking Logistic Regression (Classification)...
python classification.py
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] classification.py crashed!
    pause
    exit /b 1
)

:: 4. Execute PySpark Clustering Job
echo [2/2] Invoking K-Means (Clustering)...
python clustering.py
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] clustering.py crashed!
    pause
    exit /b 1
)

echo =======================================================
echo            Experiment 5 Completed Successfully!
echo =======================================================
pause
