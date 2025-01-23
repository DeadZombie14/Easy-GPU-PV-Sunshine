# Simple script that displays all your machine's HyperV VMs ipv4s & ipv6s in full text, for ease of access, specially when dealing with sunshine
Get-VM | ForEach-Object {
     $vmName = $_.Name
     Get-VMNetworkAdapter -VMName $vmName | Select-Object VMName, IPAddresses | Format-List
}