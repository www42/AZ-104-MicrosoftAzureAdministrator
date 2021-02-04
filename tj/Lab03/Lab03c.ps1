# Lab 03c
# -------

# Task 1: Start a PowerShell session in Azure Cloud Shell

# Task 2: Create a resource group and an Azure managed disk by using Azure PowerShell

$location = (Get-AzResourceGroup -Name az104-03b-rg1).Location
$rgName = 'az104-03c-rg1'
New-AzResourceGroup -Name $rgName -Location $location
Get-AzResourceGroup -Name $rgName

$diskConfig = New-AzDiskConfig `
 -Location $location `
 -CreateOption Empty `
 -DiskSizeGB 32 `
 -Sku Standard_LRS

$diskName = 'az104-03c-disk1'

New-AzDisk `
 -ResourceGroupName $rgName `
 -DiskName $diskName `
 -Disk $diskConfig

Get-AzDisk -ResourceGroupName $rgName -Name $diskName


# Task 3: Configure the managed disk by using Azure PowerShell

New-AzDiskUpdateConfig -DiskSizeGB 64 | Update-AzDisk -ResourceGroupName $rgName -DiskName $diskName
Get-AzDisk -ResourceGroupName $rgName -Name $diskName

Get-AzDisk | Format-Table Name,Location,DiskSizeGB

(Get-AzDisk -ResourceGroupName $rgName -Name $diskName).Sku
New-AzDiskUpdateConfig -Sku Premium_LRS | Update-AzDisk -ResourceGroupName $rgName -DiskName $diskName
(Get-AzDisk -ResourceGroupName $rgName -Name $diskName).Sku