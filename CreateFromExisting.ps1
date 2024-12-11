### This script basically replicates an existing VHDX with different hardware config and GPU PV enabled.
$params = @{
    VHDPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\GPUPV.vhdx"
    VHDNewPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\GPUPVCOPY.vhdx"
    VMName = "GPUPVCOPY"
    MemoryAmount = 4GB
    CPUCores = 6
    NetworkSwitch = "NAT Switch"
    GPUResourceAllocationPercentage = 25
    GPUName = "AUTO"
}

function Assign-VMGPUPartitionAdapter {
param(
[string]$VMName,
[string]$GPUName,
[decimal]$GPUResourceAllocationPercentage = 100
)
    
    $PartitionableGPUList = Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2" 
    if ($GPUName -eq "AUTO") {
        $DevicePathName = $PartitionableGPUList.Name[0]
        Add-VMGpuPartitionAdapter -VMName $VMName
        }
    else {
        $DeviceID = ((Get-WmiObject Win32_PNPSignedDriver | where {($_.Devicename -eq "$GPUNAME")}).hardwareid).split('\')[1]
        $DevicePathName = ($PartitionableGPUList | Where-Object name -like "*$deviceid*").Name
        Add-VMGpuPartitionAdapter -VMName $VMName -InstancePath $DevicePathName
        }

    [float]$devider = [math]::round($(100 / $GPUResourceAllocationPercentage),2)

    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionVRAM ([math]::round($(1000000000 / $devider))) -MaxPartitionVRAM ([math]::round($(1000000000 / $devider))) -OptimalPartitionVRAM ([math]::round($(1000000000 / $devider)))
    Set-VMGPUPartitionAdapter -VMName $VMName -MinPartitionEncode ([math]::round($(18446744073709551615 / $devider))) -MaxPartitionEncode ([math]::round($(18446744073709551615 / $devider))) -OptimalPartitionEncode ([math]::round($(18446744073709551615 / $devider)))
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionDecode ([math]::round($(1000000000 / $devider))) -MaxPartitionDecode ([math]::round($(1000000000 / $devider))) -OptimalPartitionDecode ([math]::round($(1000000000 / $devider)))
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionCompute ([math]::round($(1000000000 / $devider))) -MaxPartitionCompute ([math]::round($(1000000000 / $devider))) -OptimalPartitionCompute ([math]::round($(1000000000 / $devider)))

}

Function New-GPUEnabledVM {
param(
[string]$VhdPath,
[string]$VHDNewPath,
[string]$VMName,
[int64]$MemoryAmount,
[int]$CPUCores,
[string]$NetworkSwitch,
[string]$GPUName,
[float]$GPUResourceAllocationPercentage
)
    $MaxAvailableVersion = (Get-VMHostSupportedVersion).Version | Where-Object {$_.Major -lt 254}| Select-Object -Last 1 
    if (Test-Path $VHDPath) {
        Copy-Item -Path $VhdPath -Destination $VHDNewPath
        New-VM -Name $VMName -MemoryStartupBytes $MemoryAmount -VHDPath $VHDNewPath -Generation 2 -SwitchName $NetworkSwitch -Version $MaxAvailableVersion | Out-Null
        Set-VM -Name $VMName -ProcessorCount $CPUCores -CheckpointType Disabled -LowMemoryMappedIoSpace 3GB -HighMemoryMappedIoSpace 32GB -GuestControlledCacheTypes $true -AutomaticStopAction ShutDown
        Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false 
        $CPUManufacturer = Get-CimInstance -ClassName Win32_Processor | Foreach-Object Manufacturer
        $BuildVer = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        if (($BuildVer.CurrentBuild -lt 22000) -and ($CPUManufacturer -eq "AuthenticAMD")) {
            }
        Else {
            Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true
            }
        Set-VMHost -ComputerName $ENV:Computername -EnableEnhancedSessionMode $false
        # Set-VMVideo -VMName $VMName -HorizontalResolution 1920 -VerticalResolution 1080
        Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
        Enable-VMTPM -VMName $VMName 
        Assign-VMGPUPartitionAdapter -GPUName $GPUName -VMName $VMName -GPUResourceAllocationPercentage $GPUResourceAllocationPercentage
    } else {
        SmartExit -ExitReason "Failed to find VHDX, stopping script"
    }
}

New-GPUEnabledVM @params