# Author:  Adam Wu
# Date: 10/3/2020

# This script get all installed apps from the local machine and export to a CSV file.

$DisplayName = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 
$DisplayName += Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* 

$applist = $DisplayName |? { (-not ([string]::IsNullOrEmpty($_.DisplayName))) } | 
Select-Object DisplayName, DisplayVersion, Publisher | 
Sort-Object Displayname 
$applist |Export-Csv $env:TMP\applist.csv -NoTypeInformation 
$applist |Out-GridView -Wait
start $env:TMP\applist.csv 
