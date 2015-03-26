#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

# stop on all errors
$ErrorActionPreference = 'Stop';

$packageName = 'markdownpad2.portable' # arbitrary name for the package, used in messages
$url = 'http://markdownpad.com/download/markdownpad2-portable.zip' # download url
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#Install-ChocolateyZipPackage "$packageName" "$url" "$toolsDir"

# see the full list at https://github.com/chocolatey/choco/wiki/HelpersReference
# downloader that the main helpers use to download items
# if removing $url64, please remove from here
#Get-ChocolateyWebFile "$packageName" 'DOWNLOAD_TO_FILE_FULL_PATH' "$url" "$url64"
# installer, will assert administrative rights - used by Install-ChocolateyPackage
#Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" '_FULLFILEPATH_' -validExitCodes $validExitCodes
# unzips a file to the specified location - auto overwrites existing content
#Get-ChocolateyUnzip "FULL_LOCATION_TO_ZIP.zip" "$toolsDir"
# Runs processes asserting UAC, will assert administrative rights - used by Install-ChocolateyInstallPackage
#Start-ChocolateyProcessAsAdmin 'STATEMENTS_TO_RUN' 'Optional_Application_If_Not_PowerShell' -validExitCodes $validExitCodes
# add specific folders to the path - any executables found in the chocolatey package folder will already be on the path. This is used in addition to that or for cases when a native installer doesn't add things to the path.
#Install-ChocolateyPath 'LOCATION_TO_ADD_TO_PATH' 'User_OR_Machine' # Machine will assert administrative rights
# add specific files as shortcuts to the desktop
#$target = Join-Path $toolsDir "$($packageName).exe"
#Install-ChocolateyDesktopLink $target
# outputs the bitness of the OS (either "32" or "64")
#$osBitness = Get-ProcessorBits

# PORTABLE EXAMPLE
$binRoot = Get-BinRoot
$installDir = Join-Path $binRoot "$packageName"
Write-Host "Adding `'$installDir`' to the path and the current shell path"
Install-ChocolateyPath "$installDir"
$env:Path = "$($env:Path);$installDir"

# if removing $url64, please remove from here
# despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
Install-ChocolateyZipPackage "$packageName" "$url" "$installDir"
# END PORTABLE EXAMPLE
