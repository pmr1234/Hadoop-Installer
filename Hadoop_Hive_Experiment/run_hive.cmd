@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Hadoop Hive Analytical Query Runner
echo ===========================================

rem --- Set Paths ---
set "HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2"
set "HIVE_HOME=F:\apache-hive-3.1.3-bin"
set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
set "HADOOP_COMMON_HOME=%HADOOP_HOME%"
set "HADOOP_HDFS_HOME=%HADOOP_HOME%"
set "HADOOP_MAPRED_HOME=%HADOOP_HOME%"
set "HADOOP_YARN_HOME=%HADOOP_HOME%"
set "PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%"

set "HADOOP_CLASSPATH=%HADOOP_HOME%\share\hadoop\common\*;%HADOOP_HOME%\share\hadoop\common\lib\*;%HADOOP_HOME%\share\hadoop\hdfs\*;%HADOOP_HOME%\share\hadoop\hdfs\lib\*;%HADOOP_HOME%\share\hadoop\mapreduce\*;%HADOOP_HOME%\share\hadoop\yarn\*;%HADOOP_HOME%\share\hadoop\yarn\lib\*"
set "HIVE_CLASSPATH=%HIVE_HOME%\lib\*;%HIVE_HOME%\conf"
set "CP=%HIVE_CLASSPATH%;%HADOOP_CLASSPATH%"

rem --- Setup Metastore if needed ---
if not exist "metastore_db" (
    echo [1/2] Initializing Derby Metastore Database...
    java -cp "%CP%" org.apache.hive.beeline.HiveSchemaTool -dbType derby -initSchema >nul 2>&1
) else (
    echo [1/2] Derby Metastore exists. Skipping initialization.
)

rem --- Run Hive Queries ---
echo [2/2] Running Hive Analytical Queries...
echo.
java -cp "%CP%" org.apache.hadoop.hive.cli.CliDriver -f hive_queries.hql

echo.
echo ===========================================
echo   Done! All Hive queries completed successfully.
echo ===========================================
