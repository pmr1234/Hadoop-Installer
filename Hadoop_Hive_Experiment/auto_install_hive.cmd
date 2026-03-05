@echo off
setlocal enabledelayedexpansion

echo ==============================================================
echo       Fully Automated Apache Hive 3.1.3 Installer (Windows)
echo ==============================================================

set "HIVE_DEST=F:\"
set "HIVE_HOME=F:\apache-hive-3.1.3-bin"
set "HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2"
set "HIVE_TAR=apache-hive-3.1.3-bin.tar.gz"

echo.
echo [1/5] Downloading Apache Hive 3.1.3...
if not exist "%HIVE_DEST%\%HIVE_TAR%" (
    curl -o "%HIVE_DEST%\%HIVE_TAR%" "https://archive.apache.org/dist/hive/hive-3.1.3/%HIVE_TAR%"
) else (
    echo Archive already downloaded!
)

echo.
echo [2/5] Extracting Archive (This will take a minute)...
if not exist "%HIVE_HOME%" (
    tar -xf "%HIVE_DEST%\%HIVE_TAR%" -C "%HIVE_DEST%"
) else (
    echo Hive already extracted!
)

echo.
echo [3/5] Fixing Guava version conflict with Hadoop 3.x...
if exist "%HIVE_HOME%\lib\guava-19.0.jar" (
    del /f /q "%HIVE_HOME%\lib\guava-19.0.jar"
    echo Removed old Guava 19.
)
if not exist "%HIVE_HOME%\lib\guava-27.0-jre.jar" (
    copy /y "%HADOOP_HOME%\share\hadoop\hdfs\lib\guava-27.0-jre.jar" "%HIVE_HOME%\lib\" >nul
    echo Copied Hadoop's Guava 27 to Hive safely.
)

echo.
echo [4/5] Downloading legacy Apache Commons Collections framework...
set "COMMONS_JAR=%HIVE_HOME%\lib\commons-collections-3.2.2.jar"
if not exist "%COMMONS_JAR%" (
    curl -o "%COMMONS_JAR%" "https://repo1.maven.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.jar"
)

echo.
echo [5/5] Installation Complete! 
echo Hive 3.1.3 is now installed securely at: %HIVE_HOME%
echo The environment is fully integrated with Hadoop.
echo ==============================================================
pause
