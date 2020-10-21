$TemplateRoot = 'C:\git\az-104\Allfiles\Labs\07'

$location = 'eastus'
$rgName = 'az104-07-rg0'
New-AzResourceGroup -Name $rgName -Location $location

New-AzResourceGroupDeployment `
   -ResourceGroupName $rgName `
   -TemplateFile $TemplateRoot/az104-07-vm-template.json `
   -TemplateParameterFile $TemplateRoot/az104-07-vm-parameters.json `
   -AsJob

Get-Job