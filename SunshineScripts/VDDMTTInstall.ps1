# Set paths
$downloadUrl = "https://github.com/VirtualDisplay/Virtual-Display-Driver/releases/download/23.10.20.2/VDD.23.10.20.3.zip"
$extractPath = "$env:temp"
$downloadPath = "$extractPath\VDD.23.10.20.3.zip"
$sourceFolder = "$extractPath\VDD.23.10.20.2\IddSampleDriver"
$certificatePath = "C:\IddSampleDriver\Virtual_Display_Driver.cer"
$targetPath = "C:\"

# Download and extract the driver package
Write-Output "Downloading the driver package..."
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $downloadPath)
Write-Output "Extracting the driver package..."
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Move the specific folder

if (Test-Path $sourceFolder) {
    Move-Item -Path $sourceFolder -Destination $targetPath -Force
    Write-Output "Folder moved successfully to $targetPath."
} else {
    Write-Error "Error: The folder 'IddSampleDriver' was not found in the extracted archive."
}

# Add the driver certificate to trusted stores
Write-Output "Adding the driver certificate to trusted stores..."
certutil -Enterprise -Addstore "root" $certificatePath
certutil -Enterprise -Addstore "TrustedPublisher" $certificatePath

# Inform the user to complete the manual steps
Write-Output "The system is prepared for driver installation."
Write-Output "To complete the installation:
1. Open Device Manager.
2. Click on the 'Action' menu and select 'Add Legacy Hardware.'
3. Choose 'Add hardware from a list (Advanced)' and select 'Display adapters.'
4. Click 'Have Disk...' and navigate to $targetPath\IddSampleDriver\iddsampledriver.inf.
5. Follow the prompts to complete the installation.
6. Customize the resolution in display settings or disable/enable the adapter as needed.

Once complete, the virtual display driver should be installed and ready to use!"
