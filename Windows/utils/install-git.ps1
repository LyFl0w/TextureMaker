$ProgressPreference = 'SilentlyContinue'

# Setting the Git Bash download URL (portable version)
$gitBashUrl = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/PortableGit-2.42.0.2-64-bit.7z.exe"

# Setting the temporary download path
$downloadPath = "./PortableGit/GitPortableInstaller.7z.exe"

# Define extraction destination directory
$extractPath = "./PortableGit"

# Download Git Bash (portable version)
Invoke-WebRequest -Uri $gitBashUrl -OutFile $downloadPath

#  Using 7-Zip to extract files
$7ZipPath = "./utils/7z.exe"
Start-Process -NoNewWindow -Wait -FilePath $7ZipPath -ArgumentList "x", $downloadPath, "-o$extractPath", "-y"

# Cleaning up the downloaded archive file
Remove-Item $downloadPath

Write-Host "Git Bash (portable version) successfully downloaded and extracted!"