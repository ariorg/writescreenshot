#!pwsh

Set-Variable capPath -option Readonly -value '/Users/ari/OneDrive/TimeTrack/Capture' 

function WriteScreenshotWin([string]$screenShotPath) {
    Add-Type -AssemblyName System.Windows.Forms
    Add-type -AssemblyName System.Drawing
    $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
    $bitmap.Save($screenShotPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
}

function WriteScreenshotMac([string]$screenShotPath) {
    & screencapture -t jpg -x $screenShotPath 
}


$capFilename = Join-Path $PSScriptRoot 'shot.jpg'

if ($IsWindows) {
    WriteScreenShotWin $capFilename
}
elseif ($IsMacOS) {
    WriteScreenShotMac $capFilename
}
else {
    Write-Error "Only MacOS and Windows supported"
    exit
}

Write-Output "Screenshot saved to: $capFilename"

