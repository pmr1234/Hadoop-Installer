@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ===========================================
echo   Starting Interactive Hive CLI
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

echo.
echo Launching Hive... (Type 'exit;' to quit)
echo.

java -cp "%CP%" org.apache.hadoop.hive.cli.CliDriver

echo ===========================================
echo   Hive CLI Exited.
echo ===========================================
