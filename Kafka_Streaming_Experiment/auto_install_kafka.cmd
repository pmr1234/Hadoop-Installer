@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

set KAFKA_DIR=F:\kafka

if not exist "%KAFKA_DIR%" (
    echo [INFO] Downloading Apache Kafka 3.6.1 ^(Scala 2.12^)...
    curl -o kafka.tgz https://archive.apache.org/dist/kafka/3.6.1/kafka_2.12-3.6.1.tgz
    
    echo [INFO] Extracting Kafka to %KAFKA_DIR%...
    mkdir "%KAFKA_DIR%"
    tar -xzf kafka.tgz -C "%KAFKA_DIR%" --strip-components=1

    del kafka.tgz
    echo [SUCCESS] Kafka extracted successfully!
) else (
    echo [INFO] Apache Kafka is already installed at %KAFKA_DIR%.
)
