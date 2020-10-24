# Task 7 (optional)

$rgName = 'az104-08-rg02'
$lbpipName = 'az10408vmss0-ip'

$pip = (Get-AzPublicIpAddress -ResourceGroupName $rgName -Name $lbpipName).IpAddress

while ($true) { Invoke-WebRequest -Uri "http://$pip" }



# Das eigentliche Script von GitHub:
$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$letters = 70..89 | ForEach-Object { [char]$_ }
$count = 0
$label = "datadisk"

foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    $disk | 
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -UseMaximumSize -DriveLetter $driveLetter |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "$label.$count" -Confirm:$false -Force
$count++
}