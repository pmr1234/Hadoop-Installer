@echo off
set "DRIVE=%~d0"
if not defined HADOOP_HOME set "HADOOP_HOME=%DRIVE%\hadoop-3.4.2\hadoop-3.4.2"
if not defined JAVA_HOME set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
if not defined HIVE_HOME set "HIVE_HOME=%DRIVE%\apache-hive-3.1.3-bin"
set "HADOOP_COMMON_HOME=%HADOOP_HOME%"
set "HADOOP_HDFS_HOME=%HADOOP_HOME%"
set "HADOOP_MAPRED_HOME=%HADOOP_HOME%"
set "HADOOP_YARN_HOME=%HADOOP_HOME%"
set "PATH=%HIVE_HOME%\bin;%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%"

echo ===========================================
echo   Initializing Hive Metastore (Derby)
echo ===========================================
call %HIVE_HOME%\bin\schematool.cmd -dbType derby -initSchema
echo.
echo Done.
