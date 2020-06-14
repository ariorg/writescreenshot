#!pwsh

function Write-ScreenshotWin([string]$screenShotPath) {
    Add-Type -LiteralPath '/Library/Frameworks/Mono.framework/Versions/6.10.0/lib/mono/4.8-api/System.Windows.Forms.dll'  # -AssemblyName System.Windows.Forms
    Add-type -LiteralPath '/Library/Frameworks/Mono.framework/Versions/6.10.0/lib/mono/4.8-api/System.Drawing.dll'  # -AssemblyName System.Drawing
    $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
    $bitmap.Save($screenShotPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
}

function Write-ScreenshotMac([string]$screenShotPath) {
    & screencapture -t jpg -x $screenShotPath 
}

Set-Variable capPath -option Readonly -value '/Users/ari/OneDrive/TimeTrack/Capture' 

$capFilename = Join-Path $PSScriptRoot 'shot.jpg'

if ($IsWindows) {
    Write-ScreenShotWin $capFilename
}
elseif ($IsMacOS) {
    Write-ScreenShotMac $capFilename
}
else {
    Write-Error "Only MacOS and Windows supported"
    exit
}

Write-Output "Screenshot saved to: $capFilename"

