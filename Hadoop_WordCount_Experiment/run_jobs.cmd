@echo off
set "HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2"
set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
set "HADOOP_COMMON_HOME=%HADOOP_HOME%"
set "HADOOP_HDFS_HOME=%HADOOP_HOME%"
set "HADOOP_MAPRED_HOME=%HADOOP_HOME%"
set "HADOOP_YARN_HOME=%HADOOP_HOME%"
set "PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%"

set "HDFS_BASE=/user/Student"

echo [1/8] Setting up HDFS paths...
call hdfs dfs -mkdir -p %HDFS_BASE%/input

echo [2/8] Uploading input file...
call hdfs dfs -put -f "f:\vs code v2\vs-code-v2\hadoop_input\sample.txt" %HDFS_BASE%/input/sample.txt

echo [3/8] Removing old outputs if any...
call hdfs dfs -rm -r -f %HDFS_BASE%/wc_output
call hdfs dfs -rm -r -f %HDFS_BASE%/freq_output

echo [4/8] Running WordCount MapReduce Job...
call hadoop jar "f:\vs code v2\vs-code-v2\wc\exp2_wc_groupby.jar" WordCountDriver %HDFS_BASE%/input %HDFS_BASE%/wc_output

echo [5/8] Checking WordCount output...
call hdfs dfs -cat %HDFS_BASE%/wc_output/part-r-00000

echo [6/8] Running Group By Frequency MapReduce Job...
call hadoop jar "f:\vs code v2\vs-code-v2\wc\exp2_wc_groupby.jar" FrequencyDriver %HDFS_BASE%/wc_output %HDFS_BASE%/freq_output

echo [7/8] Checking Group By Frequency output...
call hdfs dfs -cat %HDFS_BASE%/freq_output/part-r-00000

echo [8/8] Done! All jobs completed.
