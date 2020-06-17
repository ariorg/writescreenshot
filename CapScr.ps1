#!pwsh
function Write-Screenshot() {
    param(
         [string]$screenShotPath
    )

    function Write-ScreenshotWin([string]$screenShotPath) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-type -AssemblyName System.Drawing

        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
        $bitmap.Save($screenShotPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }

    function Write-ScreenshotMac([string]$screenShotPath) {
        & screencapture -t jpg -x $screenShotPath 
    }

    $dateFileName = Get-Date -Format "yyyy-MM-ddTHH.mm.ss" 
    $capFilename = Join-Path $pwd "$dateFileName.jpg"

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
    # Write-Output "Screenshot saved to: $capFilename"
}
