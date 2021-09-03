Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = $PSScriptRoot
$BuildDir = "$RepoRoot\build"
$P4ApiUrl = "https://www.perforce.com/downloads/perforce/r20.2/bin.ntx86/p4api.net.zip"
$P4ApiZip = "$BuildDir\p4api.net.zip"
$P4ApiDestinations = "$RepoRoot\P4VS\libs\Release", "$RepoRoot\P4VS_StartPage\libs\Release"

# Create the build directory for our temporaries.
New-Item -Path $BuildDir -Type Directory -Force | Out-Null

# Download p4api.net.zip and extract it.
Write-Host "Downloading $P4ApiUrl"
Invoke-WebRequest -Uri $P4ApiUrl -OutFile $P4ApiZip | Out-Null
Write-Host "Extracting $P4ApiZip"
Expand-Archive -Path $P4ApiZip -DestinationPath $BuildDir -Force | Out-Null

# Copy the p4api.net dlls into each project that needs them.
foreach ($Destination in $P4ApiDestinations)
{
    Write-Host "Copying p4api.net library to $Destination"
    New-Item -Path $Destination -Type Directory -Force | Out-Null
    Copy-Item -Path "$BuildDir\p4api.net\lib\*" -Destination $Destination -Recurse | Out-Null
}

# Restore all NuGet packages.
$nuget = Start-Process -NoNewWindow -PassThru -Wait -FilePath "$RepoRoot\tools\NuGet.exe" -ArgumentList "restore P4VS.sln"
if ($nuget.ExitCode -ne 0)
{
    Write-Error "NuGet returned exit code $($nuget.ExitCode)"
}
