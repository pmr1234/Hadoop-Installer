@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo   Starting Hadoop Services (v3 - Safe)
echo ===========================================
echo.

rem 1. Set Critical Variables
set HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2
set JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481
set PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%

echo Setting HADOOP_HOME to: %HADOOP_HOME%
echo Setting JAVA_HOME to:   %JAVA_HOME%

echo.
echo ===========================================
echo   Stopping Existing Services...
echo ===========================================
echo Checking for running Hadoop processes...
echo Checking for running Hadoop processes...
powershell -NoProfile -Command "Get-Content -Path env:JAVA_HOME | ForEach-Object { & \"$_\bin\jps.exe\" } | Where-Object { $_ -match 'NameNode|DataNode|ResourceManager|NodeManager' } | ForEach-Object { $id = $_.Split(' ')[0]; Write-Host \"Stopping Hadoop process $id\"; Stop-Process -Id $id -Force -ErrorAction SilentlyContinue }"
echo Done.
echo.

rem 2. Explicitly set CLASSPATH to force Java to find JARs (including TimeLineservice Fix)
set CLASSPATH=%JAVA_HOME%\lib\tools.jar
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\etc\hadoop
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\common\lib\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\common\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\hdfs
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\hdfs\lib\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\hdfs\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\yarn
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\yarn\lib\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\yarn\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\yarn\timelineservice\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\mapreduce\lib\*
set CLASSPATH=!CLASSPATH!;%HADOOP_HOME%\share\hadoop\mapreduce\*

echo.
echo ===========================================
echo   Starting DFS Services...
echo ===========================================
start "NameNode" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_namenode -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.hdfs.server.namenode.NameNode
start "DataNode" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_datanode -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.hdfs.server.datanode.DataNode

echo.
echo ===========================================
echo   Starting YARN Services...
echo ===========================================
start "ResourceManager" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_resourcemanager -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
start "NodeManager" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_nodemanager -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.yarn.server.nodemanager.NodeManager

echo.
echo ===========================================
echo   Done! Services are starting in new windows.
echo ===========================================
echo Please verify:
echo NameNode: http://localhost:9870
echo ResourceManager: http://localhost:8088
echo.
pause
