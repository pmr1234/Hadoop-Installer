@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
if exist metastore_db rmdir /s /q metastore_db

:: Set core paths
set "HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2"
set "HIVE_HOME=F:\apache-hive-3.1.3-bin"
set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
set "PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%"

set "HADOOP_CLASSPATH=%HADOOP_HOME%\share\hadoop\common\*;%HADOOP_HOME%\share\hadoop\common\lib\*;%HADOOP_HOME%\share\hadoop\hdfs\*;%HADOOP_HOME%\share\hadoop\hdfs\lib\*;%HADOOP_HOME%\share\hadoop\mapreduce\*;%HADOOP_HOME%\share\hadoop\yarn\*;%HADOOP_HOME%\share\hadoop\yarn\lib\*"
set "HIVE_CLASSPATH=%HIVE_HOME%\lib\*;%HIVE_HOME%\conf"
set "CP=%HIVE_CLASSPATH%;%HADOOP_CLASSPATH%"

echo ===========================================
echo   Initializing Hive Metastore (Derby)
echo ===========================================
java -cp "%CP%" org.apache.hive.beeline.HiveSchemaTool -dbType derby -initSchema
echo.
echo ===========================================
echo   Running a Quick Hive Test
echo ===========================================
java -cp "%CP%" org.apache.hadoop.hive.cli.CliDriver -e "SHOW DATABASES;"
echo.
echo Done.
