#!pwsh
function Write-Screenshot() {
    param(
         [string]$FolderPath = $pwd
    )

    function Write-ScreenshotWin([string]$filename) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-type -AssemblyName System.Drawing

        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
        $bitmap.Save($filename, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }

    function Write-ScreenshotMac([string]$filename) {
        & screencapture -t jpg -x $filename 
    }

    $dateFileName = Get-Date -Format "yyyy-MM-ddTHH.mm.ss" 
    $capFilename = Join-Path $FolderPath "$dateFileName.jpg"
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
