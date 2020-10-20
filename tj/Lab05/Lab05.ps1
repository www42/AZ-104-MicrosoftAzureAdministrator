# Task 1: Provision the lab environment
# -------------------------------------
$location1 = 'westeurope'
$location2 = 'northeurope'
$rgName1 = 'az104-05-rg0'
$rgName2 = 'az104-05-rg1'
$rgName3 = 'az104-05-rg2'
New-AzResourceGroup -Name $rgName1 -Location $location1
New-AzResourceGroup -Name $rgName2 -Location $location1
New-AzResourceGroup -Name $rgName3 -Location $location2

$TemplateRoot = 'C:\git\az-104\Allfiles\Labs\05'

New-AzResourceGroupDeployment `
-ResourceGroupName $rgName1 `
-TemplateFile "$TemplateRoot/az104-05-vnetvm-template.json" `
-TemplateParameterFile "$TemplateRoot/az104-05-vnetvm-parameters.json" `
-nameSuffix 0 `
-AsJob

New-AzResourceGroupDeployment `
-ResourceGroupName $rgName2 `
-TemplateFile "$TemplateRoot/az104-05-vnetvm-template.json" `
-TemplateParameterFile "$TemplateRoot/az104-05-vnetvm-parameters.json" `
-nameSuffix 1 `
-AsJob

New-AzResourceGroupDeployment `
-ResourceGroupName $rgName3 `
-TemplateFile "$TemplateRoot/az104-05-vnetvm-template.json" `
-TemplateParameterFile "$TemplateRoot/az104-05-vnetvm-parameters.json" `
-nameSuffix 2 `
-AsJob

Get-Job
Receive-Job -Id 1 -Keep

Get-AzResourceGroup | sort ResourceGroupName | ft ResourceGroupName,Location
Get-AzVM -Status | where ResourceGroupName -Like "AZ104-05*" | sort Name | Format-Table Name,PowerState,ResourceGroupName,Location
# Get-AzVM -Status | where {$_.ResourceGroupName -Like "AZ104-05*" -and $_.PowerState -eq "VM running"} | 
#     Stop-AzVM -Force

# Task 2: Configure local and global virtual network peering
# ----------------------------------------------------------
