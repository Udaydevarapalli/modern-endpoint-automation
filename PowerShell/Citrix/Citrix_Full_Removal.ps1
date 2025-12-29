# =================================================
# Citrix Full Removal Script (Enterprise Final)
# =================================================

$ErrorActionPreference = 'SilentlyContinue'
$logFile = "C:\Windows\Temp\Citrix_Full_Removal.log"

function Log {
    param ($msg)
    Write-Output $msg
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $msg"
}

Log "===== Citrix Full Removal Started ====="

# -------------------------------------------------
# REGISTRY PATHS
# -------------------------------------------------
$RegistryPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

# -------------------------------------------------
# STEP 1: DISCOVERY
# -------------------------------------------------
Log "--- Discovery Phase ---"

$CitrixApps = @()

foreach ($path in $RegistryPaths) {
    Get-ItemProperty $path | Where-Object {
        $_.DisplayName -like 'Citrix*' -or
        $_.DisplayName -like 'Microsoft Teams VDI Citrix*'
    } | ForEach-Object {

        $CitrixApps += $_

        Log "FOUND:"
        Log "  Name    : $($_.DisplayName)"
        Log "  Version : $($_.DisplayVersion)"
        Log "  Vendor  : $($_.Publisher)"
        Log "  UninstallString : $($_.UninstallString)"
        Log "--------------------------------------"
    }
}

if (-not $CitrixApps) {
    Log "No Citrix products detected"
}

# -------------------------------------------------
# STEP 2: REMOVE MSI CHILD COMPONENTS
# -------------------------------------------------
Log "--- MSI Child Component Removal ---"

foreach ($app in $CitrixApps | Where-Object {
    $_.UninstallString -match 'MsiExec' -and
    $_.DisplayName -notmatch '^Citrix Workspace [0-9]'
}) {

    $guid = ($app.UninstallString -split '{')[-1] -replace '}.*',''
    if ($guid) {
        Log "Removing MSI: $($app.DisplayName)"
        Log "GUID: {$guid}"

        Start-Process msiexec.exe `
            -ArgumentList "/x {$guid} /qn /norestart" `
            -Wait
    }
}

# -------------------------------------------------
# STEP 3: SILENT UNINSTALL OF CITRIX WORKSPACE (ANY VERSION)
# -------------------------------------------------
Log "--- Citrix Workspace Silent Uninstall ---"

$Workspace = $CitrixApps | Where-Object {
    $_.DisplayName -match '^Citrix Workspace [0-9]'
}

if ($Workspace) {
    foreach ($ws in $Workspace) {

        $exePath = ($ws.UninstallString -split '"')[1]

        if (Test-Path $exePath) {
            Log "Removing Workspace: $($ws.DisplayName)"
            Log "Bootstrapper: $exePath"

            Start-Process -FilePath $exePath `
                -ArgumentList "/uninstall /silent /cleanup /norestart" `
                -Wait `
                -WindowStyle Hidden
        }
        else {
            Log "ERROR: Bootstrapper not found for $($ws.DisplayName)"
        }
    }
}
else {
    Log "No Citrix Workspace detected"
}

# -------------------------------------------------
# STEP 4: POST CLEANUP
# -------------------------------------------------
Log "--- Cleanup Phase ---"

Get-Process | Where-Object { $_.Name -like 'Citrix*' } | Stop-Process -Force

$Folders = @(
    "$env:ProgramFiles\Citrix",
    "$env:ProgramFiles(x86)\Citrix"
)

foreach ($folder in $Folders) {
    if (Test-Path $folder) {
        Log "Removing folder: $folder"
        Remove-Item $folder -Recurse -Force
    }
}

# -------------------------------------------------
# STEP 5: REMOVE PUBLIC DESKTOP SHORTCUT
# -------------------------------------------------
$PublicShortcut = "C:\Users\Public\Desktop\Citrix Applications.url"

if (Test-Path $PublicShortcut) {
    Log "Removing Public Desktop shortcut: $PublicShortcut"
    Remove-Item $PublicShortcut -Force
}
else {
    Log "Public Desktop shortcut not found"
}

Log "===== Citrix Full Removal Completed ====="
