
# PowerShell Gallery
Find-Module -Name AzureAD
Find-Module -Name AzureAD | Install-Module -Force
Get-Module -ListAvailable -Name AzureAD

# Microsoft Docs
Start-Process https://docs.microsoft.com/en-us/powershell/azure/active-directory/overview?view=azureadps-2.0

# PowerShell Version
$PSVersionTable
Import-Module -Name AzureAD

Get-Command -Module AzureAD | Measure-Object | % Count
Get-Command -Module AzureAD | Group-Object Noun | Sort-Object Count -Descending | Format-Table Count,Name

# AzureAD
Get-Command -Module AzureAD | ? Noun -EQ "AzureAD"
Connect-AzureAD

# AzureADDomain
Get-AzureADDomain | Format-Table Name,IsInitial,IsVerified,IsDefault

# AzureADUser
Get-Command -Module AzureAD | ? Noun -EQ "AzureADUser"
Get-AzureADUser | Get-Member -MemberType Properties
Get-AzureADUser | Format-Table DisplayName,UserPrincipalName,UserType,UsageLocation
Get-AzureADUser -Filter "userPrincipalName eq 'Albert@einstein4711.onmicrosoft.com'" | Format-List -Property *


$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = 'Pa55w.rd1234'
$PasswordProfile.ForceChangePasswordNextLogin = $true

New-AzureADUser `
    -AccountEnabled $true `
    -PasswordProfile $PasswordProfile `
    -DisplayName "Niels Bohr" `
    -UserPrincipalName "Niels@einstein4711.onmicrosoft.com" `
    -GivenName "Niels" `
    -Surname "Bohr" `
    -City "Copenhagen" `
    -UsageLocation "DK" `
    -Department "Theory" `
    -JobTitle "Theoretical Physicist" `
    -TelephoneNumber "47110816" `
    -MailNickname "Niels"
    
    
Get-AzureADUser -Filter "userPrincipalName eq 'Niels@einstein4711.onmicrosoft.com'" | Format-List -Property *

# AzureADMSAdministrativeUnit
Get-AzureADMSAdministrativeUnit -All:$true
New-AzureADMSAdministrativeUnit -DisplayName "Quantum Electodynamics"