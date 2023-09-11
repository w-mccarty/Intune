#Add script & IntuneWinAppUtil.exe in directory such as C:\Intune
# Modify install filename as needed
$install_filename = 'install.ps1'
#
$App_directory = (Get-Location).path

if (Test-Path -Path "$App_directory\archive") {
} else {
    New-Item -Path "$App_directory\archive" -ItemType Directory | Out-Null
    Write-Host "$App_directory\archive directory created" -ForegroundColor Gray
}
if (Test-Path -Path "$App_directory\in") {
} else {
    New-Item -Path "$App_directory\in" -ItemType Directory | Out-Null
    Write-Host "$App_directory\in directory created" -ForegroundColor Gray
}
Write-Host "$App_directory\IntuneWinAppUtil.exe = expected location of IntuneWinAppUtil" -ForegroundColor Gray
if (Test-Path -Path "$App_directory\IntuneWinAppUtil.exe") {
    Write-Host "$App_directory\in\ = directory for all install files" -ForegroundColor Gray
    Write-Host "$App_directory\in\$install_filename = expected installer file from script settings" -ForegroundColor Gray
    if (Test-Path -Path "$App_directory\in\$install_filename") {
        Write-Host "$App_directory\in\$install_filename found.  Preparing to create install.intunewin file" -ForegroundColor Green
        Write-Host "Enter Application Name (ie: Explorer)" -ForegroundColor Yellow
        $AppName = Read-Host
        if (Test-Path -Path "$App_directory\archive\$AppName") {
        } else {
            New-Item -Path "$App_directory\archive\$AppName" -ItemType Directory | Out-Null
        }
        $FolderCount = (Get-ChildItem -Path "$App_directory\archive\$AppName" | Measure-Object).Count + 1
        $VersionPath = "$App_directory\archive\$AppName\$($AppName)_$($FolderCount)"
        Write-Host "Creating $AppName version $FolderCount in $VersionPath" -ForegroundColor Gray
        New-Item -Path $VersionPath -ItemType Directory | Out-Null
        Remove-Item "$($App_directory)\*.intunewin" -Force
        Start-Process -FilePath "$App_directory\IntuneWinAppUtil.exe" -ArgumentList ("-c $App_directory\in","-s $install_filename","-o $App_directory","-q")
        While (Get-Process -Name IntuneWinAppUtil -ErrorAction SilentlyContinue) {
            Write-Host "IntuneWinAppUtil is running..." -ForegroundColor Gray
            Sleep 3
        }
        Write-Host "IntuneWinAppUtil completed" -ForegroundColor Green
        Rename-Item -Path "$App_directory\install.intunewin" -NewName "install_$($AppName)_$($FolderCount).intunewin"
        Write-Host "$App_directory\install_$($AppName)_$($FolderCount).intunewin created" -ForegroundColor Green
        Write-Host "Continue to work with existing input files (y) or move all files to archive? (any other input)" -ForegroundColor Yellow
        $ModifyCurrent = Read-Host
        if ($ModifyCurrent -eq "y") {
            New-Item -Path "$VersionPath\in" -ItemType Directory | Out-Null
            Copy-Item "$App_directory\in\*" -Destination "$VersionPath\in"
            Copy-Item -Path "$App_directory\install_$($AppName)_$($FolderCount).intunewin" -Destination $VersionPath
            Write-Host "All files left intact, current version is archived at $VersionPath" -ForegroundColor Green
        } else {
            Move-Item -Path "$App_directory\in" -Destination $VersionPath
            New-Item -Path "$App_directory\in" -ItemType Directory | Out-Null
            Copy-Item -Path "$App_directory\install_$($AppName)_$($FolderCount).intunewin" -Destination $VersionPath
            Write-Host "All input files removed, current version is archived at $VersionPath" -ForegroundColor Green   
        }
    } else {
        Write-Host "$App_directory\in\$install_filename not found.  Unable to proceed" -BackgroundColor Red
    } 
} else {
    Write-Host "$App_directory\IntuneWinAppUtil.exe not found.  Unable to proceed" -BackgroundColor Red
}
