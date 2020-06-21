function Write-Screenshot() {
    <#
    .Synopsis
    Takes a screenshot and stores it in a file

    .DESCRIPTION
    Captures a screenshot of the current screen and stores it as jpg-file in the 
    supplied directory. By default the file is named by the current date and time 
    like so 2024-06-20_10.06.37.jpg.
    
    .PARAMETER Interval
    The Interval in seconds between creating a new screenshot.

    .PARAMETER Times
    Specifies how many times to create a screenshots, waiting -Interval seconds 
    between each. The script will run forever if Times is set to 0.
    
    .EXAMPLE
    Write-Screenshot

    Creates a screenshot file in the format 2024-06-20_10.06.37.jpg in the 
    current directory.

    .EXAMPLE
    Write-Screenshot C:\MyStuff\Screenshots

    Creates a screenshot file C:\MyStuff\Screenshots\2024-06-20_10.06.37.jpg 

    .EXAMPLE
    Write-Screenshot -FolderPath /Screenshots -Filename screenshot10

    Creates a screenshot file /Screenshots/screenshot10.jpg
    
    .EXAMPLE
    Write-Screenhot -FolderPath /Screenshots -Interval 600 -Times 10
    
    Creates screenshot every 10 minutes in /Screenshots as 2024-06-20_10.06.37.jpg, 
    2024-06-20_20.06.37.jpg, 024-06-30_10.06.37.jpg etc.
    #>
 
    [CmdletBinding()]
    [OutputType([string])]
    
    param(
        [string]$FolderPath = $pwd,
        [string]$Filename,

        [ValidateRange(1, [int]::MaxValue)]
        [int]$Interval = 60,

        [ValidateRange(0, [int]::MaxValue)]
        [int]$Times = 1
    )

    function WriteScreenshotWin([string]$filepath) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-type -AssemblyName System.Drawing

        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
        $bitmap.Save($filepath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }

    function WriteScreenshotMac([string]$filepath) {
        & screencapture -t jpg -x $filepath 
    }

    function WriteScreenshotAnyPlatform([string]$filepath) {
        if ($IsWindows) {
            WriteScreenShotWin $filepath
        }
        elseif ($IsMacOS) {
            WriteScreenShotMac $filepath
        }
        elseif ($IsLinux) {
            Write-Error "Write-Screenshot is not supported on Linux"
        }
        else {
            Write-Error "Write-Screenshot is only supported on MacOS and Windows"
        }
    }

    function BaseFileName([string] $suppliedFilename) {
        if ($suppliedFilename) {
           return $suppliedFilename
        }
        return (Get-Date -Format "yyyy-MM-dd_HH.mm.ss")
    }

    if (!(Test-Path $FolderPath)) {
        New-Item -ItemType Directory -Path $FolderPath | Out-Null
    }

    $timesLeft = $Times

    while (($Times -eq 0) -or ($timesLeft-- -gt 0)) {
        $capFilename = Join-Path (Resolve-Path $FolderPath) "$(BaseFileName($Filename)).jpg"
        WriteScreenshotAnyPlatform $capFilename
        if ($timesLeft -ge 1) {
            Start-Sleep -Seconds $Interval
        }
    }
}
