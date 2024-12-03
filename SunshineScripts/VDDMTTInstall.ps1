# Set paths
$downloadUrl = "https://github.com/VirtualDisplay/Virtual-Display-Driver/releases/download/23.12.2HDR/IddSampleDriver.zip"
$downloadPath = "C:\Users\$env:USERNAME\Downloads\IddSampleDriver.zip"
$extractPath = "C:\"
$certificatePath = "C:\IddSampleDriver\Virtual_Display_Driver.cer"

# Download and extract the driver package
Write-Output "Downloading the driver package..."
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $downloadPath)
Write-Output "Extracting the driver package..."
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Add the driver certificate to trusted stores
Write-Output "Adding the driver certificate to trusted stores..."
certutil -Enterprise -Addstore "root" $certificatePath
certutil -Enterprise -Addstore "TrustedPublisher" $certificatePath

# Ensure options.txt is accessible
if (-Not (Test-Path "$extractPath\IddSampleDriver\options.txt")) {
    Write-Error "Error: options.txt not found at $extractPath. Ensure the file is available and try again."
    exit 1
}

Write-Output "The system is prepared for driver installation."

# Inform the user to complete the manual steps
Write-Output "To complete the installation:
1. Open Device Manager.
2. Click on the 'Action' menu and select 'Add Legacy Hardware.'
3. Choose 'Add hardware from a list (Advanced)' and select 'Display adapters.'
4. Click 'Have Disk...' and navigate to $extractPath\IddSampleDriver\iddsampledriver.inf.
5. Follow the prompts to complete the installation.
6. Customize the resolution in display settings or disable/enable the adapter as needed.

Once complete, the virtual display driver should be installed and ready to use!"
