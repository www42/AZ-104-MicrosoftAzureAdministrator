# Task 7 (optional)

$rgName = 'az104-08-rg02'
$lbpipName = 'az10408vmss0-ip'

$pip = (Get-AzPublicIpAddress -ResourceGroupName $rgName -Name $lbpipName).IpAddress

while ($true) { Invoke-WebRequest -Uri "http://$pip" }