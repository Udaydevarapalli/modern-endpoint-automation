# Add Devices to SCCM Collection from CSV

This PowerShell script adds devices to an SCCM device collection using
a list of device names provided in a CSV file.

## Use Case
Useful when you need to:
- Bulk target devices for an application deployment
- Quickly add known devices to a direct membership collection
- Avoid manual collection edits in the console

## Requirements
- Run from an SCCM admin console machine
- SCCM PowerShell module loaded
- Appropriate permissions to modify collections

## How It Works
1. Reads device names from a CSV file
2. Looks up each device in SCCM
3. Adds valid devices as direct membership rules
4. Triggers a collection update

## Example CSV
Device01
Device02
Device03

markdown
Copy code

## Script
`Add-DevicesToCollectionFromCSV.ps1`
