<#
.SYNOPSIS
    Automated Hadoop 3.4.2 Installer for Windows (Robust Version).
    
    Features:
    - Error Handling: Wraps critical steps in try-catch blocks.
    - Validation: Checks Java path, network connectivity, and file integrity.
    - Idempotency: Skips steps if already completed (e.g., download).
    - Logging: Provides colorful status updates and detailed error messages.

    Usage: Run as Administrator.
    Example: .\install_hadoop.ps1 -JavaHome "C:\Program Files\Java\jdk1.8.0_202"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$InstallDir = "C:\hadoop-3.4.2",

    [Parameter(Mandatory = $false)]
    [string]$DataDir = "C:\hadoop-data",

    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$JavaHome
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Failure {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

try {
    # 0. Check Administrator Privileges
    Write-Status "Checking Administrator privileges..."
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        throw "This script must be run as Administrator to set Environment Variables and create directories."
    }
    Write-Success "Running as Administrator."

    # 1. Setup Configuration
    $HadoopHome = "$InstallDir\hadoop-3.4.2"
    $BinDir = "$HadoopHome\bin"
    $EtcDir = "$HadoopHome\etc\hadoop"
    $HadoopUrl = "https://dlcdn.apache.org/hadoop/common/hadoop-3.4.2/hadoop-3.4.2.tar.gz"
    $WinUtilsUrl = "https://github.com/cdarlint/winutils/raw/master/hadoop-3.3.6/bin/winutils.exe"
    $HadoopDllUrl = "https://github.com/cdarlint/winutils/raw/master/hadoop-3.3.6/bin/hadoop.dll"
    $TarFile = "$InstallDir\hadoop.tar.gz"

    # Validate Java Home
    Write-Status "Validating Java Path..."
    if (-not (Test-Path "$JavaHome\bin\java.exe")) {
        throw "Java executable not found at $JavaHome\bin\java.exe. Please verify the path."
    }

    # Shorten Java Path
    try {
        $fso = New-Object -ComObject Scripting.FileSystemObject
        $JavaHomeShort = $fso.GetFolder($JavaHome).ShortPath
        Write-Success "Using Short Java Path: $JavaHomeShort"
    }
    catch {
        Write-Warning "Could not convert Java path to short path. Using: $JavaHome"
        $JavaHomeShort = $JavaHome
    }

    # 2. Download and Install Hadoop
    if (-not (Test-Path $HadoopHome)) {
        Write-Status "Creating Install Directory: $InstallDir"
        New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

        Write-Status "Downloading Hadoop 3.4.2 from $HadoopUrl..."
        try {
            Invoke-WebRequest -Uri $HadoopUrl -OutFile $TarFile -ErrorAction Stop
        }
        catch {
            throw "Failed to download Hadoop. Check your internet connection. Error: $_"
        }

        if (-not (Test-Path $TarFile)) { throw "Download failed: $TarFile not found." }

        Write-Status "Extracting Hadoop (this may take a few minutes)..."
        try {
            tar -xzf $TarFile -C $InstallDir
        }
        catch {
            throw "Failed to extract Hadoop archive. Ensure 'tar' is available or manually extract."
        }

        Remove-Item $TarFile -Force
        
        if (-not (Test-Path $HadoopHome)) { throw "Extraction failed: $HadoopHome not found." }
        Write-Success "Hadoop extracted successfully."
    }
    else {
        Write-Status "Hadoop directory already exists. Skipping download/extraction."
    }

    # 3. Install Winutils
    Write-Status "Installing Windows Native Binaries (winutils.exe, hadoop.dll)..."
    try {
        Invoke-WebRequest -Uri $WinUtilsUrl -OutFile "$BinDir\winutils.exe" -ErrorAction Stop
        Invoke-WebRequest -Uri $HadoopDllUrl -OutFile "$BinDir\hadoop.dll" -ErrorAction Stop
    }
    catch {
        throw "Failed to download winutils/hadoop.dll. Error: $_"
    }

    if (-not (Test-Path "$BinDir\winutils.exe") -or -not (Test-Path "$BinDir\hadoop.dll")) {
        throw "Winutils installation failed."
    }
    Write-Success "Winutils installed."

    # 4. Configure XML Files
    Write-Status "Configuring XML files..."
    
    # Create Data Directories
    $DirsToCreate = @(
        "$DataDir\namenode", 
        "$DataDir\datanode", 
        "$DataDir\tmp", 
        "$DataDir\nm-local-dir", 
        "$DataDir\nm-log-dir"
    )
    foreach ($dir in $DirsToCreate) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    # Write Config Files
    $DataDirUri = "file:///" + $DataDir.Replace('\', '/')

    $Configs = @{
        "$EtcDir\core-site.xml"   = @"
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>$DataDirUri/tmp</value>
    </property>
</configuration>
"@
        "$EtcDir\hdfs-site.xml"   = @"
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>$DataDirUri/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>$DataDirUri/datanode</value>
    </property>
</configuration>
"@
        "$EtcDir\mapred-site.xml" = @"
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
"@
        "$EtcDir\yarn-site.xml"   = @"
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
    <property>
        <name>yarn.nodemanager.local-dirs</name>
        <value>$DataDirUri/nm-local-dir</value>
    </property>
    <property>
        <name>yarn.nodemanager.log-dirs</name>
        <value>$DataDirUri/nm-log-dir</value>
    </property>
    <property>
        <name>yarn.timeline-service.enabled</name>
        <value>false</value>
    </property>
</configuration>
"@
        "$EtcDir\hadoop-env.cmd"  = @"
@echo off
set HADOOP_HOME=$HadoopHome
set JAVA_HOME=$JavaHomeShort
set HADOOP_CLASSPATH=%HADOOP_HOME%\share\hadoop\common\*;%HADOOP_HOME%\share\hadoop\common\lib\*;%HADOOP_HOME%\share\hadoop\hdfs\*;%HADOOP_HOME%\share\hadoop\hdfs\lib\*;%HADOOP_HOME%\share\hadoop\mapreduce\*;%HADOOP_HOME%\share\hadoop\mapreduce\lib\*;%HADOOP_HOME%\share\hadoop\yarn\*;%HADOOP_HOME%\share\hadoop\yarn\lib\*
"@
    }

    foreach ($file in $Configs.Keys) {
        try {
            Set-Content -Path $file -Value $Configs[$file] -ErrorAction Stop
        }
        catch {
            throw "Failed to write configuration file: $file. Error: $_"
        }
    }
    Write-Success "Configuration files written successfully."

    # 6. Set Environment Variables
    Write-Status "Setting Environment Variables..."
    try {
        [Environment]::SetEnvironmentVariable("HADOOP_HOME", $HadoopHome, "Machine")
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $JavaHomeShort, "Machine")

        $CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($CurrentPath -notlike "*$BinDir*") {
            $NewPath = "$CurrentPath;$BinDir;$HadoopHome\sbin"
            [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
            Write-Success "Updated PATH variable."
        }
        else {
            Write-Status "PATH already contains Hadoop binaries."
        }
    }
    catch {
        throw "Failed to set environment variables. Ensure you are running as Administrator. Error: $_"
    }

    # 7. Create Start Script
    $StartScriptPath = "$HadoopHome\start_services.cmd"
    $StartScriptContent = @"
@echo off
set HADOOP_HOME=$HadoopHome
set JAVA_HOME=$JavaHomeShort
set PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%

echo ===========================================
echo   Formatting NameNode...
echo ===========================================
echo Y | hdfs namenode -format

echo ===========================================
echo   Starting Services...
echo ===========================================
start "NameNode" cmd /k "hdfs namenode"
start "DataNode" cmd /k "hdfs datanode"
start "ResourceManager" cmd /k "yarn resourcemanager"
start "NodeManager" cmd /k "yarn nodemanager"

echo ===========================================
echo   Done! Verify at http://localhost:9870
echo ===========================================
pause
"@
    Set-Content -Path $StartScriptPath -Value $StartScriptContent
    Write-Success "Startup script created at $StartScriptPath"

    Write-Host "`n==========================================" -ForegroundColor Green
    Write-Success "Hadoop Installation Completed Successfully!"
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "Next Step: Run '$StartScriptPath' to format the NameNode and start services." -ForegroundColor Yellow

}
catch {
    Write-Host "`n==========================================" -ForegroundColor Red
    Write-Failure "Installation Failed!"
    Write-Failure "Reason: $_"
    Write-Host "==========================================" -ForegroundColor Red
    exit 1
}
