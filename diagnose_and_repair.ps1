<#
.SYNOPSIS
    Hadoop Data Directory Diagnostic & Auto-Repair Tool
    
    This script:
    1. Checks if Java can *actually* read/write the data directory (using real Java code, not just PowerShell).
    2. If Java fails (despite PowerShell saying permissions are fine), it AUTOMATICALLY relocates the data directory.
    3. New Location: C:\hadoop-data (Root) with explicit "Everyone" permissions.
    4. Updates all Hadoop XML configs to point to the new location.

    Usage: Run as Administrator.
    Example: .\diagnose_and_repair.ps1 -JavaHome "C:\Program Files\Java\jdk1.8.0_202"
#>

param (
    [Parameter(Mandatory = $false)]
    [string]$JavaHome,
    
    [Parameter(Mandatory = $false)]
    [switch]$ForceRelocate
)

$ErrorActionPreference = "Stop"
$JavaSrc = @"
import java.io.File;
public class DiskTest {
    public static void main(String[] args) {
        if (args.length == 0) { System.exit(1); }
        File f = new File(args[0]);
        System.out.println("Testing path: " + f.getAbsolutePath());
        
        if (!f.exists()) {
            System.out.println("Result: MISSING");
            System.exit(2);
        }
        if (!f.isDirectory()) {
            System.out.println("Result: NOT_DIRECTORY");
            System.exit(3);
        }
        boolean canRead = f.canRead();
        boolean canWrite = f.canWrite();
        boolean canExec = f.canExecute();
        
        System.out.println("canRead: " + canRead);
        System.out.println("canWrite: " + canWrite);
        System.out.println("canExecute: " + canExec);
        
        if (!canRead || !canWrite) {
            System.exit(1);
        }
        System.exit(0);
    }
}
"@

function Write-Status { param([string]$msg); Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param([string]$msg); Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-ErrorMsg { param([string]$msg); Write-Host "[ERROR] $msg" -ForegroundColor Red }

# 1. Check Admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-ErrorMsg "Must run as Administrator."
    exit 1
}

# 2. Find Java
if (-not $JavaHome) {
    $JavaHome = $env:JAVA_HOME
}

# Sanitize Input: If user provided ...\bin or ...\java.exe, fix it.
if ($JavaHome.EndsWith("\bin") -or $JavaHome.EndsWith("\bin\")) {
    $JavaHome = (Get-Item $JavaHome).Parent.FullName
}
elseif ($JavaHome.EndsWith("java.exe")) {
    $JavaHome = (Get-Item $JavaHome).Directory.Parent.FullName
}

if (-not $JavaHome -or -not (Test-Path "$JavaHome\bin\javac.exe")) {
    Write-ErrorMsg "JDK not found at: $JavaHome"
    Write-ErrorMsg "Please provide -JavaHome parameter pointing to your JDK."
    exit 1
}

# 3. Compile Test Class
Write-Status "Compiling Java Disk Tester..."
Set-Content -Path "DiskTest.java" -Value $JavaSrc
& "$JavaHome\bin\javac.exe" DiskTest.java

# 4. Identify Current Configured Data Dir
$HadoopHome = $env:HADOOP_HOME
if (-not $HadoopHome) { $HadoopHome = "C:\hadoop-3.4.2\hadoop-3.4.2" }
$HdfsSite = "$HadoopHome\etc\hadoop\hdfs-site.xml"

if (-not (Test-Path $HdfsSite)) {
    Write-ErrorMsg "Configuration file not found: $HdfsSite"
    exit 1
}

[xml]$xml = Get-Content $HdfsSite
$CurrentDataDir = $xml.configuration.property | Where-Object { $_.name -eq "dfs.datanode.data.dir" } | Select-Object -ExpandProperty value
# Cleanup file:/// prefix and forward slashes
$CurrentDataDir = $CurrentDataDir -replace "file:///", "" -replace "/", "\"
# Remove /datanode suffix to get base dir
$CurrentBaseDir = $CurrentDataDir -replace "\\datanode$", ""

Write-Status "Current Data Base Directory: $CurrentBaseDir"
$TestTarget = "$CurrentBaseDir\datanode"

# 5. Run Test
Write-Status "Running Access Test on: $TestTarget"
& "$JavaHome\bin\java.exe" DiskTest "$TestTarget"
$result = $LASTEXITCODE

if ($result -eq 0 -and -not $ForceRelocate) {
    Write-Success "Java reports this directory is FULLY ACCESSIBLE."
    Write-Host "If Hadoop still fails, likely the 'Student' user cannot access what 'Admin' can."
    Write-Host "Re-run this script with -ForceRelocate to move data to C:\hadoop-data (Recommended)."
}
else {
    if ($ForceRelocate) {
        Write-Status "Force Relocation Requested."
    }
    else {
        Write-ErrorMsg "Java reports ACCESS DENIED (Exit Code: $result)."
    }
    Write-Status "Fixing by Relocating Data Directory..."
    
    # 6. AUTO-FIX: Relocate to C:\hadoop-data (Simpler Path)
    Write-Host "`n[AUTO-FIX] Relocating Data Directory to C:\hadoop-data..." -ForegroundColor Yellow
    
    $NewBaseDir = "C:\hadoop-data"
    
    # Clean old if exists
    if (Test-Path $NewBaseDir) { 
        Write-Status "Cleaning old C:\hadoop-data..."
        Remove-Item $NewBaseDir -Recurse -Force -ErrorAction SilentlyContinue 
    }
    
    New-Item -ItemType Directory -Path "$NewBaseDir\namenode" -Force | Out-Null
    New-Item -ItemType Directory -Path "$NewBaseDir\datanode" -Force | Out-Null
    New-Item -ItemType Directory -Path "$NewBaseDir\tmp" -Force | Out-Null
    New-Item -ItemType Directory -Path "$NewBaseDir\nm-local-dir" -Force | Out-Null
    New-Item -ItemType Directory -Path "$NewBaseDir\nm-log-dir" -Force | Out-Null
    
    # Force Permissions
    Write-Status "Applying permissions to new directory..."
    icacls "$NewBaseDir" /reset /t /q
    icacls "$NewBaseDir" /grant "Everyone:(OI)(CI)F" /t /q
    attrib -r "$NewBaseDir" /s /d
    
    # Update Configs
    Write-Status "Updating Hadoop XML Configurations..."
    $BaseUri = "file:///C:/hadoop-data"
    
    # Function to update XML property
    function Update-Xml {
        param($file, $name, $val)
        [xml]$x = Get-Content $file
        $node = $x.configuration.property | Where-Object { $_.name -eq $name }
        if ($node) { $node.value = $val } else {
            $e = $x.CreateElement("property")
            $n = $x.CreateElement("name"); $n.InnerText = $name
            $v = $x.CreateElement("value"); $v.InnerText = $val
            $e.AppendChild($n); $e.AppendChild($v)
            $x.configuration.AppendChild($e)
        }
        $x.Save($file)
    }
    
    Update-Xml "$HadoopHome\etc\hadoop\core-site.xml" "hadoop.tmp.dir" "$BaseUri/tmp"
    Update-Xml "$HadoopHome\etc\hadoop\hdfs-site.xml" "dfs.namenode.name.dir" "$BaseUri/namenode"
    Update-Xml "$HadoopHome\etc\hadoop\hdfs-site.xml" "dfs.datanode.data.dir" "$BaseUri/datanode"
    Update-Xml "$HadoopHome\etc\hadoop\yarn-site.xml" "yarn.nodemanager.local-dirs" "$BaseUri/nm-local-dir"
    Update-Xml "$HadoopHome\etc\hadoop\yarn-site.xml" "yarn.nodemanager.log-dirs" "$BaseUri/nm-log-dir"
    
    Write-Success "Relocation Complete."
    Write-Host "IMPORTANT: You must FORMAT the NameNode again because the data location changed." -ForegroundColor Yellow
    Write-Host "Run: cmd /c `"$HadoopHome\bin\hdfs.cmd namenode -format -force`"" -ForegroundColor Yellow
}
