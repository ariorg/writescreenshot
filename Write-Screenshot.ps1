function Write-Screenshot() {
    <#
    .SYNOPSIS
    Takes a screenshot and stores it in a file

    .DESCRIPTION
    Captures a screenshot of the current screen and stores it as jpg-file in the 
    supplied directory. By default the file is named by the current date and time 
    like so 2024-06-20T10.06.37.jpg.
    
    .PARAMETER FolderPath
    Path of the folder where the captured screenshots will be saved.

    .PARAMETER Filename
    Specifies the filename of the screenshot file. Overrides the default
    filename format of 2024-06-20T10.06.37.jpg.

    .PARAMETER Interval
    The Interval in seconds between creating a new screenshot.

    .PARAMETER Times
    Specifies how many times to create a screenshots, waiting -Interval seconds 
    between each. 
    
    .PARAMETER Forever
    Runs the screen capture forever. Overrides the Times parameter.

    .EXAMPLE
    Write-Screenshot

    Creates a screenshot file in the format 2024-06-20T10.06.37.jpg in the 
    current directory.

    .EXAMPLE
    Write-Screenshot C:\MyStuff\Screenshots

    Creates a screenshot file C:\MyStuff\Screenshots\2024-06-20T10.06.37.jpg 

    .EXAMPLE
    Write-Screenshot -FolderPath /Screenshots -Filename screenshot10

    Creates a screenshot file /Screenshots/screenshot10.jpg
    
    .EXAMPLE
    Write-Screenhot -FolderPath /Screenshots -Interval 600 -Times 10
    
    Creates screenshot every 10 minutes in /Screenshots as 2024-06-20T10.06.37.jpg, 
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
        [int]$Times = 1,

        [switch]$Forever
    )

    function _writeScreenshotWin([string]$filepath) {
        Add-Type -AssemblyName System.Windows.Forms
        Add-type -AssemblyName System.Drawing

        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphic.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bitmap.Size)
        $bitmap.Save($filepath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }

    function _writeScreenshotMac([string]$filepath) {
        & screencapture -t jpg -x $filepath 
    }

    function WriteScreenshotAnyPlatform([string]$filepath) {
        if ($IsWindows) {
            _writeScreenShotWin $filepath
        }
        elseif ($IsMacOS) {
            _writeScreenShotMac $filepath
        }
        else {
            Write-Error "Write-Screenshot is only supported on MacOS and Windows"
        }
    }

    if (!(Test-Path $FolderPath)) {
        New-Item -ItemType Directory -Path $FolderPath | Out-Null
    }

    $timesLeft = $Times
    while (($timesLeft -gt 0) -or $Forever) {
        [string]$baseFilename = $Filename ? $Filename : (Get-Date -Format "yyyy-MM-ddTHH.mm.ss")
        [string]$capFilename = Join-Path (Resolve-Path $FolderPath) "$baseFilename.jpg"
        WriteScreenshotAnyPlatform $capFilename

        if ($timesLeft -gt 1) {
            Start-Sleep -Seconds $Interval
        }
        
        if ($Forever -and $script:isRunningUnderTest) {
            break
        }

        $timesLeft--
    }
}
