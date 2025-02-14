# Simple script that displays all your machine's HyperV VMs ipv4s & ipv6s in full text, for ease of access, specially when dealing with sunshine
$outputFile = "index.html"
Get-VM | ForEach-Object {
     $vmName = $_.Name
     Get-VMNetworkAdapter -VMName $vmName | Select-Object VMName, IPAddresses | Format-List
} | Format-List | Out-File -Encoding utf8 $outputFile
