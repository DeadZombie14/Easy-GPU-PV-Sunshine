# Generate a new UUID for sunshine, as it is stupid enough to not let you do this while on the web interface
# VERY USEFUL when cloning VMs, as they keep the same UUID thus screwing up moonlight
$newUuid = [guid]::NewGuid().ToString()
Write-Output "Generated UUID: $newUuid"
$filePath = "C:\Program Files\Sunshine\config\sunshine_state.json"

if (Test-Path $filePath) {
    $fileContent = Get-Content $filePath -Raw
    $updatedContent = $fileContent -replace '"uuid":\s*"[a-zA-Z0-9-]+"', '"uuid": "' + $newUuid + '"'

    Set-Content $filePath $updatedContent
    Write-Output "Updated Sunshine state file with new UUID."
} else {
    Write-Output "Sunshine state file not found. Generated UUID: $newUuid"
}