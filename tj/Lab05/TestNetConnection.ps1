[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$target,
    [Parameter(Mandatory=$false)][int]$port = 3389
)
Test-NetConnection -ComputerName $target -Port $port -InformationLevel 'Detailed'