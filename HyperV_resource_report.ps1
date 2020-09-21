#Created by https://github.com/VladimirKosyuk

#Outputs as sum VHD, RAM, CPU for all VM that stored on HyperV cluster. I know about Get-HyperVReport, but i want to simplify this task
#
# Build date: 21.09.2020									   
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Store_size = Get-VM -ComputerName (Get-ClusterNode) | where {($_.State -eq 'Running') -and ($_.Name -notlike '*test*')} | ForEach-Object {
Get-VHD -ComputerName $_.ComputerName -VMId $_.VMId} | Select -Property path,computername,vhdtype,@{label='Size(GB)';expression={$_.filesize/1gb -as [int]}}
$Ram_size = Get-VM -ComputerName (Get-ClusterNode) | where {($_.State -eq 'Running') -and ($_.Name -notlike '*test*')} | Select-Object VMName, @{label='Size(GB)';expression={$_.MemoryAssigned/1gb -as [int]}}
$CPU_size = Get-VM -ComputerName (Get-ClusterNode) | where {($_.State -eq 'Running') -and ($_.Name -notlike '*test*')} | Select-Object VMName, ProcessorCount

Write-output ("VHD "+($Store_size | Select-Object -ExpandProperty 'Size(GB)' | measure -sum | Select-Object -ExpandProperty 'SUM')+" GB")
Write-output ("RAM "+($Ram_size | Select-Object -ExpandProperty 'Size(GB)' | measure -sum | Select-Object -ExpandProperty 'SUM')+" GB")
Write-output ("CPU "+($CPU_size | Select-Object -ExpandProperty 'ProcessorCount' | measure -sum | Select-Object -ExpandProperty 'SUM')+" GB")

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue
