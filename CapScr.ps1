#!pwsh
function Write-Screenshot() {
    param(
         [string]$FolderPath = $pwd,
         [string]$Filename 
    )

    function Write-ScreenshotWin([string]$filepath) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-type -AssemblyName System.Drawing

        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
        $bitmap.Save($filepath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }

    function Write-ScreenshotMac([string]$filepath) {
        & screencapture -t jpg -x $filepath 
    }

    $baseFileName = Get-Date -Format "yyyy-MM-ddTHH.mm.ss" 
    if ($Filename) {
        $baseFileName = $Filename
    }
    
    $capFilename = Join-Path $FolderPath "$baseFileName.jpg"
    
    if (!(Test-Path $FolderPath)) {
            New-Item -ItemType Directory -Path $FolderPath | Out-Null
    }
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
}
