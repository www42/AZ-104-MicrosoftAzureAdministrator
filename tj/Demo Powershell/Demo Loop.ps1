
$location = "westeurope"
$rgName = "Projekt43-RG"

New-AzResourceGroup -Name $rgName -Location $location

for ($i = 1; $i -le 3; $i++) {
    New-AzRouteTable `
        -Location $location `
        -ResourceGroupName $rgName `
        -Name "RT$i"
}

Get-AzRouteTable | Format-Table Name,ResourceGroupName

Remove-AzResourceGroup -Name $rgName -Force