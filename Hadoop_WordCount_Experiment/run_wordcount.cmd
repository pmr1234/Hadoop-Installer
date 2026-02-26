@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo   Hadoop WordCount and Frequency Runner
echo ===========================================
echo.

if "%~1"=="" (
    echo Usage: run_wordcount.cmd ^<path_to_input_file^>
    echo Example: run_wordcount.cmd my_data.txt
    exit /b 1
)

set INPUT_FILE=%~f1
if not exist "%INPUT_FILE%" (
    echo Error: Input file "%INPUT_FILE%" does not exist.
    exit /b 1
)

rem --- Set Hadoop and Java paths ---
set "HADOOP_HOME=F:\hadoop-3.4.2\hadoop-3.4.2"
set "JAVA_HOME=C:\Progra~1\Java\jdk1.8.0_481"
set "HADOOP_COMMON_HOME=%HADOOP_HOME%"
set "HADOOP_HDFS_HOME=%HADOOP_HOME%"
set "HADOOP_MAPRED_HOME=%HADOOP_HOME%"
set "HADOOP_YARN_HOME=%HADOOP_HOME%"
set "PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%"

set "HDFS_BASE=/user/%USERNAME%"
set "PROJECT_DIR=%~dp0wc"
set "JAR_FILE=%PROJECT_DIR%\exp2_wc_groupby.jar"

rem --- 1. Compile Java if JAR missing ---
if not exist "%JAR_FILE%" (
    echo [1/8] Compiling Java files and building JAR...
    if not exist "%PROJECT_DIR%\classes" mkdir "%PROJECT_DIR%\classes"
    
    dir "%PROJECT_DIR%\src\*.java" /b /s > "%PROJECT_DIR%\sources.txt"
    javac -classpath "%HADOOP_HOME%\share\hadoop\common\*;%HADOOP_HOME%\share\hadoop\mapreduce\*" -d "%PROJECT_DIR%\classes" @"%PROJECT_DIR%\sources.txt"
    if !ERRORLEVEL! NEQ 0 (
        echo Compilation failed.
        exit /b 1
    )
    
    pushd "%PROJECT_DIR%\classes"
    jar -cvf "%JAR_FILE%" *
    popd
) else (
    echo [1/8] JAR already exists. Skipping compilation.
)

rem --- 2. HDFS Setup ---
echo [2/8] Setting up HDFS paths...
call hdfs dfs -mkdir -p %HDFS_BASE%/input

echo [3/8] Uploading input file...
call hdfs dfs -put -f "%INPUT_FILE%" %HDFS_BASE%/input/sample.txt

echo [4/8] Removing old HDFS outputs if any...
call hdfs dfs -rm -r -f %HDFS_BASE%/wc_output
call hdfs dfs -rm -r -f %HDFS_BASE%/freq_output

rem --- 3. Execute MapReduce ---
echo [5/8] Running WordCount MapReduce Job...
call hadoop jar "%JAR_FILE%" WordCountDriver %HDFS_BASE%/input %HDFS_BASE%/wc_output

echo [6/8] WordCount Output:
call hdfs dfs -cat %HDFS_BASE%/wc_output/part-r-00000

echo [7/8] Running Group By Frequency MapReduce Job...
call hadoop jar "%JAR_FILE%" FrequencyDriver %HDFS_BASE%/wc_output %HDFS_BASE%/freq_output

echo [8/8] Group By Frequency Output:
call hdfs dfs -cat %HDFS_BASE%/freq_output/part-r-00000

echo.
echo ===========================================
echo   Done! All jobs completed successfully.
echo ===========================================
