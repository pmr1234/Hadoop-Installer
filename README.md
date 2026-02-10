# Hadoop Automated Installer for Windows

This repository contains a PowerShell script to automate the installation and configuration of **Apache Hadoop 3.4.2** on Windows.

## Features
- **Automated Downloads**: Fetches Hadoop 3.4.2 and required native binaries (`winutils.exe`, `hadoop.dll`).
- **One-Click Setup**: Configures `core-site.xml`, `hdfs-site.xml`, `mapred-site.xml`, `yarn-site.xml`, and `hadoop-env.cmd` automatically.
- **Environment Variables**: Sets `HADOOP_HOME`, `JAVA_HOME`, and updates `PATH`.
- **Desktop Launcher**: Creates a `Run Hadoop.cmd` shortcut on your Desktop.
- **Robust Error Handling**: Validates Java path, network connection, and file integrity.

## Prerequisites
- **Java 8 (JDK 1.8)**: Must be installed before running the script.
- **Administrator Privileges**: Required to set system environment variables.

## Usage

1. **Clone this repository** (or download `install_hadoop.ps1`).
2. Open **PowerShell as Administrator**.
3. Run the following command:

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
.\install_hadoop.ps1 -JavaHome "C:\Program Files\Java\jdk1.8.0_202"
```

*(Replace the path with your actual JDK 8 installation path)*

## What Happens Next?
The script will:
1. Download artifacts to `C:\hadoop-3.4.2`.
2. Format the NameNode.
3. Start all Hadoop services.
4. Place a shortcut on your Desktop.

## Verification
After installation, verify that Hadoop is running by visiting:
- **NameNode UI**: http://localhost:9870
- **ResourceManager UI**: http://localhost:8088
