# Download sunshine
(New-Object System.Net.WebClient).DownloadFile("https://github.com/LizardByte/Sunshine/releases/latest/download/sunshine-windows-installer.exe", "C:\Users\$env:USERNAME\Downloads\sunshine-windows-installer.exe")

# Install silently
Start-Process "C:\Users\$env:USERNAME\Downloads\sunshine-windows-installer.exe" -ArgumentList "/S"

# Inform the user to complete the manual steps
Write-Output "To complete the installation:
1. Open sunshine, set up a password
2. Establish a PIN to your client PC
3. Make sure to set windows to display stuff on virtual monitor only (or make it your primary one).

Once completed, you will be able to use sunshine with your new virtual display!"