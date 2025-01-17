# Set paths
$downloadUrl = "https://github.com/VirtualDisplay/Virtual-Display-Driver/releases/download/24.10.27/VirtualDisplayDriver-x64.zip"
$extractPath = "$env:temp"
$downloadPath = "$extractPath\VirtualDisplayDriver.zip"
$sourceFolder = "$extractPath\VirtualDisplayDriver"
$certificatePath = "C:\VirtualDisplayDriver\Virtual_Display_Driver.cer"
$targetPath = "C:\"
$infFilePath = "$targetPath\VirtualDisplayDriver\MttVDD.inf"

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
    Write-Error "Error: The folder 'VirtualDisplayDriver' was not found in the extracted archive."
}

# Add the driver certificate to trusted stores
Write-Output "Adding the driver certificate to trusted stores..."
certutil -Enterprise -Addstore "root" $certificatePath
certutil -Enterprise -Addstore "TrustedPublisher" $certificatePath

# Install the driver
Write-Output "Installing the virtual display driver..."
if (Test-Path $infFilePath) {
    Start-Process -FilePath "pnputil.exe" -ArgumentList "/add-driver `"$infFilePath`" /install" -NoNewWindow -Wait
    Write-Output "Driver installed successfully."
} else {
    Write-Error "Error: The INF file '$infFilePath' was not found. Check the extracted folder structure."
    exit 1
}

# Inform the user to complete the manual steps
Write-Output "The system is prepared for driver installation."
Write-Output "To complete the installation:
1. Open Device Manager.
2. Click on the 'Display adapters' menu and select 'Add Legacy Hardware.' from the top menu.
3. Choose 'Add hardware from a list (Advanced)' and select 'Display adapters.'
4. Choose the recently added MikeTheTech display adapter.
5. Follow the prompts to complete the installation.
6. Customize the resolution in display settings or disable/enable the adapter as needed.

Once complete, the virtual display driver should be installed and ready to use!"

# TODO: self-download WDK so we can fully automate the VDD device install
# Add new display by using devcon to add a new device (requires Windows Driver Kit)
# $devconPath = "C:\Path\To\devcon.exe" # Update with the actual path to devcon.exe
# if (Test-Path $devconPath) {
#     Start-Process -FilePath $devconPath -ArgumentList "install `"$infFilePath`" ROOT\VIRTUALDISPLAY" -NoNewWindow -Wait
#     Write-Output "Virtual display device added successfully."
# } else {
#     Write-Error "Error: devcon.exe not found. Install the Windows Driver Kit (WDK) and update the path."
# }