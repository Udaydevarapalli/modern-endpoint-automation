<#
.SYNOPSIS
Adds devices to an SCCM device collection using a CSV list.

.DESCRIPTION
Reads a list of device names from a CSV file and adds them as direct
membership rules to a specified SCCM device collection.

Useful for bulk targeting applications or deployments.

.NOTES
Author: Uday Kumar
#>

$CollectionName = "Yourcollectionname"
$DeviceList = Get-Content "C:\Temp\Devices.csv"

foreach ($Device in $DeviceList) {
    $Resource = Get-CMDevice -Name $Device -ErrorAction SilentlyContinue
    if ($Resource) {
        Add-CMDeviceCollectionDirectMembershipRule `
            -CollectionName $CollectionName `
            -ResourceId $Resource.ResourceId
        Write-Host "Added: $Device" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Device not found in SCCM: $Device" -ForegroundColor Red
    }
}

Invoke-CMDeviceCollectionUpdate -Name $CollectionName
