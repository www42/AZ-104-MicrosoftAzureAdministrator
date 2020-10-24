# Task 1: Provision the lab environment
# -------------------------------------

$TemplateRoot = 'C:\git\az-104\Allfiles\Labs\06'

$location = 'westus2'

# Resource group 1 - template vms
$rgName1 = 'az104-06-rg1'
New-AzResourceGroup -Name $rgName1 -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $rgName1 `
    -TemplateFile $TemplateRoot/az104-06-vms-template.json `
    -TemplateParameterFile $TemplateRoot/az104-06-vm-parameters.json `
    -AsJob

# Resource group 2 - template vm (ohne 's') nameSuffix = 2
$rgName2 = 'az104-06-rg2'
New-AzResourceGroup -Name $rgName2 -Location $location
New-AzResourceGroupDeployment `
    -ResourceGroupName $rgName2 `
    -TemplateFile $TemplateRoot/az104-06-vm-template.json `
    -TemplateParameterFile $TemplateRoot/az104-06-vm-parameters.json `
    -nameSuffix 2 `
    -AsJob

# Resource group 3 - template vm (ohne 's') nameSuffix = 3
$rgName3 = 'az104-06-rg3'
New-AzResourceGroup -Name $rgName3 -Location $location
New-AzResourceGroupDeployment `
   -ResourceGroupName $rgName3 `
   -TemplateFile $TemplateRoot/az104-06-vm-template.json `
   -TemplateParameterFile $TemplateRoot/az104-06-vm-parameters.json `
   -nameSuffix 3 `
   -AsJob



# Task 2: Configure the hub and spoke network topology
# ----------------------------------------------------