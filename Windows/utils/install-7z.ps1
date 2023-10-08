$ProgressPreference = 'SilentlyContinue'

# 7z download URL definition (portable version)
$gitBashUrl = "https://www.7-zip.org/a/7zr.exe"

# 7z path definition
$downloadPath = "./utils/7z.exe"

# Download 7z
Invoke-WebRequest -Uri $gitBashUrl -OutFile $downloadPath

Write-Host "7z has been successfully installed!"