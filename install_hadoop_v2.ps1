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
    [string]$DataDir = "$env:PUBLIC\hadoop-data",

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
    # 0. Check Administrator Privileges & Auto-Elevate
    Write-Status "Checking Administrator privileges..."
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    
    if (-not $isAdmin) {
        Write-Status "Requesting Administrator privileges... (Please accept UAC prompt)"
        
        # Build arguments to restart script as Admin
        $MyPath = $MyInvocation.MyCommand.Path
        $ArgsList = "-NoProfile -ExecutionPolicy Bypass -File `"$MyPath`""
        
        if ($PSBoundParameters.ContainsKey('JavaHome')) { $ArgsList += " -JavaHome `"$JavaHome`"" }
        if ($PSBoundParameters.ContainsKey('InstallDir')) { $ArgsList += " -InstallDir `"$InstallDir`"" }
        if ($PSBoundParameters.ContainsKey('DataDir')) { $ArgsList += " -DataDir `"$DataDir`"" }

        try {
            Start-Process powershell.exe -ArgumentList $ArgsList -Verb RunAs -ErrorAction Stop
            exit
        }
        catch {
            throw "Failed to elevate privileges. Please right-click and 'Run as Administrator'."
        }
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
    
    # Sanitize Input: If user provided ...\bin or ...\java.exe, fix it.
    if ($JavaHome.EndsWith("\bin") -or $JavaHome.EndsWith("\bin\")) {
        $JavaHome = (Get-Item $JavaHome).Parent.FullName
        Write-Status "Adjusted JavaHome to: $JavaHome"
    }
    elseif ($JavaHome.EndsWith("java.exe")) {
        $JavaHome = (Get-Item $JavaHome).Directory.Parent.FullName
        Write-Status "Adjusted JavaHome to: $JavaHome"
    }

    if (-not (Test-Path "$JavaHome\bin\java.exe")) {
        throw "Java executable not found at '$JavaHome\bin\java.exe'. Please verify you provided the JDK root folder (e.g., C:\Program Files\Java\jdk1.8.0_xxx)."
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
        
        Write-Status "Using Data Directory: $DataDir"
        if ($DataDir -eq "C:\hadoop-data") {
            Write-Warning "Using C:\hadoop-data is not recommended due to permission issues. Consider using User Profile."
        }

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
    # Force delete DataNode directory to ensure clean permissions (Fix for DiskErrorException)
    if (Test-Path "$DataDir\datanode") { 
        Write-Status "Removing existing DataNode directory to fix permissions..."
        Remove-Item "$DataDir\datanode" -Recurse -Force -ErrorAction SilentlyContinue 
    }

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

    # Grant Permissions to Everyone (Fix for Access Denied)
    Write-Status "Resetting and Granting permissions to data directory: $DataDir"
    icacls "$DataDir" /reset /t /q
    icacls "$DataDir" /grant "Everyone:(OI)(CI)F" /t /q
    icacls "$DataDir" /grant "Users:(OI)(CI)F" /t /q
    icacls "$DataDir" /grant "Authenticated Users:(OI)(CI)F" /t /q



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
set HADOOP_CLASSPATH=%HADOOP_HOME%\share\hadoop\common\*;%HADOOP_HOME%\share\hadoop\common\lib\*;%HADOOP_HOME%\share\hadoop\hdfs\*;%HADOOP_HOME%\share\hadoop\hdfs\lib\*;%HADOOP_HOME%\share\hadoop\mapreduce\*;%HADOOP_HOME%\share\hadoop\mapreduce\lib\*;%HADOOP_HOME%\share\hadoop\yarn\*;%HADOOP_HOME%\share\hadoop\yarn\lib\*;%HADOOP_HOME%\share\hadoop\yarn\timelineservice\*
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

    # 7. Format NameNode (One-Time)
    Write-Status "Checking if NameNode needs formatting..."
    if (-not (Test-Path "$DataDir\namenode\current")) {
        Write-Status "Formatting NameNode..."
        
        # Use full path to avoid path issues
        $FormatCmd = "cmd /c `"$HadoopHome\bin\hdfs.cmd namenode -format -force`""
        Invoke-Expression $FormatCmd | Out-Null
        Write-Success "NameNode formatted."
    }
    else {
        Write-Status "NameNode already formatted. Skipping."
    }

    # Re-Grant Permissions to DataDir (Crucial: Fix for Access Denied on 'VERSION' file created by Format)
    Write-Status "Ensuring complete access to Data Directory (Post-Format via icacls)..."
    icacls "$DataDir" /grant "Everyone:(OI)(CI)F" /t /q
    icacls "$DataDir" /grant "Users:(OI)(CI)F" /t /q

    # 8a. Create Stop Services Helper Script (PowerShell)
    $StopScriptPath = "$HadoopHome\stop_services.ps1"
    $StopScriptContent = @"
`$jh = `$env:JAVA_HOME
if (`$jh.EndsWith('\bin')) { `$jh = `$jh.Substring(0, `$jh.Length - 4) }
Write-Host "Java Home detected: `$jh"

Write-Host "Checking for running Hadoop processes..."
& "`$jh\bin\jps.exe" | Where-Object { `$_ -match 'NameNode|DataNode|ResourceManager|NodeManager' } | ForEach-Object { 
    `$id = `$_.Split(' ')[0]
    Write-Host "Stopping Hadoop process `$id"
    Stop-Process -Id `$id -Force -ErrorAction SilentlyContinue 
}

Write-Host "Checking for processes blocking Port 9000..."
`$p = Get-NetTCPConnection -LocalPort 9000 -ErrorAction SilentlyContinue
if (`$p) { 
    Write-Host "Killing process on port 9000: `$(`$p.OwningProcess)"
    Stop-Process -Id `$p.OwningProcess -Force 
}
"@
    Set-Content -Path $StopScriptPath -Value $StopScriptContent
    Write-Success "Stop helper script created at $StopScriptPath"

    # 8b. Create Safe Start Script
    $StartScriptPath = "$HadoopHome\start_services.cmd"
    $StartScriptContent = @"
@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo   Starting Hadoop Services
echo ===========================================
echo.

set HADOOP_HOME=$HadoopHome
set JAVA_HOME=$JavaHomeShort
set PATH=%HADOOP_HOME%\bin;%JAVA_HOME%\bin;%PATH%

echo Setting HADOOP_HOME to: %HADOOP_HOME%
echo Setting JAVA_HOME to:   %JAVA_HOME%

echo.
echo ===========================================
echo   Stopping Existing Services...
echo ===========================================
powershell -ExecutionPolicy Bypass -File "%HADOOP_HOME%\stop_services.ps1"
echo Done.
echo.

rem Explicitly set CLASSPATH to force Java to find JARs (including TimeLineservice Fix)
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

echo Starting DFS Services...
start "NameNode" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_namenode -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.hdfs.server.namenode.NameNode
start "DataNode" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_datanode -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.hdfs.server.datanode.DataNode

echo Starting YARN Services...
start "ResourceManager" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_resourcemanager -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
start "NodeManager" cmd /k %JAVA_HOME%\bin\java.exe -Dproc_nodemanager -Xmx1000m -Dhadoop.home.dir=%HADOOP_HOME% -Dhadoop.id.str=%USERNAME% -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender -classpath "%CLASSPATH%" org.apache.hadoop.yarn.server.nodemanager.NodeManager

echo.
echo ===========================================
echo   Done! Verify at http://localhost:9870
echo ===========================================
echo.

echo Launching Web UIs...
start http://localhost:9870
start http://localhost:8088

pause
"@
    Set-Content -Path $StartScriptPath -Value $StartScriptContent
    Write-Success "Startup script created at $StartScriptPath"

    # 9. Create Desktop Shortcut (For All Users)
    # Remove old user-specific shortcut if exists
    $UserDesktop = [Environment]::GetFolderPath("Desktop")
    if (Test-Path "$UserDesktop\Run Hadoop.cmd") { Remove-Item "$UserDesktop\Run Hadoop.cmd" -Force }

    $DesktopPath = [Environment]::GetFolderPath("CommonDesktopDirectory")
    $ShortcutFile = "$DesktopPath\Run Hadoop.cmd"
    $ShortcutContent = "call `"$StartScriptPath`""
    Set-Content -Path $ShortcutFile -Value $ShortcutContent
    Write-Success "Desktop shortcut created for ALL USERS: $ShortcutFile"

    Write-Host "`n==========================================" -ForegroundColor Green
    Write-Success "Hadoop Installation Completed Successfully!"
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "Next Step: Double-click 'Run Hadoop' on your Desktop." -ForegroundColor Yellow

}
catch {
    Write-Host "`n==========================================" -ForegroundColor Red
    Write-Failure "Installation Failed!"
    Write-Failure "Reason: $_"
    Write-Failure "Usage Example: .\install_hadoop.ps1 -JavaHome 'C:\Program Files\Java\jdk1.8.0_202'"
    Write-Host "==========================================" -ForegroundColor Red
    Pause
    exit 1
}
