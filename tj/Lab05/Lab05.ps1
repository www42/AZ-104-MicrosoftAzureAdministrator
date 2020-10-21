# AZ-104 Lab 05 - Implement Intersite Connectivity
# =================================================

# Task 1: Provision the lab environment
# -------------------------------------

# Resource groups
$location1 = 'westeurope'
$location2 = 'northeurope'

$rgName1 = 'az104-05-rg0'
$rgName2 = 'az104-05-rg1'
$rgName3 = 'az104-05-rg2'

New-AzResourceGroup -Name $rgName1 -Location $location1
New-AzResourceGroup -Name $rgName2 -Location $location1
New-AzResourceGroup -Name $rgName3 -Location $location2

Get-AzResourceGroup | where ResourceGroupName -Like "AZ104-05*" | sort ResourceGroupName | ft ResourceGroupName,Location

# Deploy ARM template three times
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

Get-AzVM -Status | where ResourceGroupName -Like "AZ104-05*" | sort Name | Format-Table Name,PowerState,ResourceGroupName,Location

# Get-AzVM -Status | where {$_.ResourceGroupName -Like "AZ104-05*" -and $_.PowerState -eq "VM running"} | Stop-AzVM -Force -AsJob

Get-AzVM -Status | where {$_.ResourceGroupName -Like "AZ104-05*" -and $_.PowerState -eq "VM deallocated"} | 
    Start-AzVM -AsJob

$Vm0 = Get-AzVM -Name "az104-05-vm0"
$Vm1 = Get-AzVM -Name "az104-05-vm1"
$Vm2 = Get-AzVM -Name "az104-05-vm2"



# Task 2: Configure local and global virtual network peering
# ----------------------------------------------------------
$Vnet0 = Get-AzVirtualNetwork -Name "az104-05-vnet0"
$Vnet1 = Get-AzVirtualNetwork -Name "az104-05-vnet1"
$Vnet2 = Get-AzVirtualNetwork -Name "az104-05-vnet2"

$Peering01 = "az104-05-vnet0_to_az104-05-vnet1"
$Peering10 = "az104-05-vnet1_to_az104-05-vnet0"

$Peering02 = "az104-05-vnet0_to_az104-05-vnet2"
$Peering20 = "az104-05-vnet2_to_az104-05-vnet0"

$Peering12 = "az104-05-vnet1_to_az104-05-vnet2"
$Peering21 = "az104-05-vnet2_to_az104-05-vnet1"

Add-AzVirtualNetworkPeering -Name $Peering01  -VirtualNetwork $Vnet0 -RemoteVirtualNetworkId $Vnet1.Id
Add-AzVirtualNetworkPeering -Name $Peering10  -VirtualNetwork $Vnet1 -RemoteVirtualNetworkId $Vnet0.Id

Add-AzVirtualNetworkPeering -Name $Peering02  -VirtualNetwork $Vnet0 -RemoteVirtualNetworkId $Vnet2.Id
Add-AzVirtualNetworkPeering -Name $Peering20  -VirtualNetwork $Vnet2 -RemoteVirtualNetworkId $Vnet0.Id

Add-AzVirtualNetworkPeering -Name $Peering12  -VirtualNetwork $Vnet1 -RemoteVirtualNetworkId $Vnet2.Id
Add-AzVirtualNetworkPeering -Name $Peering21  -VirtualNetwork $Vnet2 -RemoteVirtualNetworkId $Vnet1.Id


Get-AzVirtualNetworkPeering -VirtualNetworkName $Vnet0.Name -ResourceGroupName $rgName1 | 
    ft Name,PeeringState,AllowVirtualNetworkAccess,AllowForwardedTraffic,AllowGatewayTransit,UseRemoteGateways

Get-AzVirtualNetworkPeering -VirtualNetworkName $Vnet1.Name -ResourceGroupName $rgName2 | 
    ft Name,PeeringState,AllowVirtualNetworkAccess,AllowForwardedTraffic,AllowGatewayTransit,UseRemoteGateways

Get-AzVirtualNetworkPeering -VirtualNetworkName $Vnet2.Name -ResourceGroupName $rgName3 | 
    ft Name,PeeringState,AllowVirtualNetworkAccess,AllowForwardedTraffic,AllowGatewayTransit,UseRemoteGateways



# Task 3: Test intersite connectivity
# ------------------------------------

# Test 0 --> 1
Invoke-AzVMRunCommand `
    -VMName $Vm0.Name `
    -ResourceGroupName $rgName1 `
    -CommandId "RunPowerShellScript" `
    -ScriptPath "TestNetConnection.ps1" `
    -Parameter @{target = "10.51.0.4"; port = 3389}

# Test 0 --> 2
Invoke-AzVMRunCommand `
    -VMName $Vm0.Name `
    -ResourceGroupName $rgName1 `
    -CommandId "RunPowerShellScript" `
    -ScriptPath "TestNetConnection.ps1" `
    -Parameter @{target = "10.52.0.4"; port = 3389}

# Test 1 --> 2
Invoke-AzVMRunCommand `
    -VMName $Vm1.Name `
    -ResourceGroupName $rgName2 `
    -CommandId "RunPowerShellScript" `
    -ScriptPath "TestNetConnection.ps1" `
    -Parameter @{target = "10.52.0.4"; port = 3389}



# Clean up resources
# ------------------
Get-AzResourceGroup -Name 'az104-05*'
# Get-AzResourceGroup -Name 'az104-05*' | Remove-AzResourceGroup -Force -AsJob