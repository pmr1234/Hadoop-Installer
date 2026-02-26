@echo off
set "HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2"
set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
set "HADOOP_COMMON_HOME=%HADOOP_HOME%"
set "HADOOP_HDFS_HOME=%HADOOP_HOME%"
set "HADOOP_MAPRED_HOME=%HADOOP_HOME%"
set "HADOOP_YARN_HOME=%HADOOP_HOME%"
set "PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%"

call hdfs dfs -mkdir -p /user/hive/warehouse
call hdfs dfs -chmod g+w /user/hive/warehouse
call hdfs dfs -mkdir -p /tmp/hive
call hdfs dfs -chmod g+w /tmp/hive
echo Done initializing HDFS for Hive.
