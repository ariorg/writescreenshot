# $here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"
    
Context "The initial Write-ScreenshotWin tests" {
    Describe "CapScr Test Group" {

        It "should be create screenshot jpg file" {
                . ./CapScr.ps1
                $capFilename = Join-Path $PSScriptRoot 'shot.jpg'
                Remove-Item $capFilename -ErrorAction Ignore
                Write-ScreenshotWin $capFilename
                $capFilename | Should -Exist
                Remove-Item $capFilename -ErrorAction Ignore
        }
    }
}
