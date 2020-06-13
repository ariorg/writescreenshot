Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
    }
    Context 'Write-ScreenshotWin tests' {
        It 'should create screenshot jpg file' {
            $capFilename = Join-Path $PSScriptRoot 'shot.jpg'
            Remove-Item $capFilename -ErrorAction Ignore
            Write-ScreenshotWin $capFilename
            $capFilename | Should -Exist
            Remove-Item $capFilename -ErrorAction Ignore
        }
    }
}
