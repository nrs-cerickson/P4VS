Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$P4ApiUrl = "https://www.perforce.com/downloads/perforce/r20.2/bin.ntx86/p4api.net.zip"
$P4ApiZip = "p4api.net.zip"
$P4ApiDestinations = "P4VS\libs\Release", "P4VS_StartPage\libs\Release"

Invoke-WebRequest -Uri $P4ApiUrl -OutFile $P4ApiZip
Expand-Archive -Path $P4ApiZip -DestinationPath "." -Force

foreach ($Destination in $P4ApiDestinations)
{
    Write-Host "Copying p4api.net library to $Destination"
    New-Item -Path $Destination -Type Directory -Force
    Copy-Item -Path "p4api.net\lib\*" -Destination $Destination -Recurse
}

tools\NuGet.exe restore P4VS.sln
