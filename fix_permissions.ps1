$ErrorActionPreference = "Stop"

function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

# Check Admin Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "[ERROR] You must run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    exit 1
}

$DataDir = "$env:PUBLIC\hadoop-data"

Write-Status "Targeting Data Directory: $DataDir"

if (-not (Test-Path $DataDir)) {
    Write-Host "[ERROR] Directory not found: $DataDir" -ForegroundColor Red
    Write-Host "Please run the main installer first."
    exit 1
}

Write-Status "Checking current ownership..."
try {
    $acl = Get-Acl $DataDir
    Write-Host "Current Owner: $($acl.Owner)"
}
catch {
    Write-Host "Could not read ACL (Access Denied)" -ForegroundColor Red
}

Write-Status "Forcefully resetting permissions..."

# 1. Reset Inheritance
icacls "$DataDir" /reset /t /q

# 2. Grant explicit Full Control to Everyone
icacls "$DataDir" /grant "Everyone:(OI)(CI)F" /t /q
icacls "$DataDir" /grant "Users:(OI)(CI)F" /t /q
icacls "$DataDir" /grant "Authenticated Users:(OI)(CI)F" /t /q

Write-Success "Permissions reset complete."
Write-Host "Please try running Hadoop again (Double-click 'Run Hadoop' on desktop)." -ForegroundColor Cyan
