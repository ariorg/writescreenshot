Describe "CapScr Test Group" {

    Context "Pester tests" {
        It "Pester should work" {
            $true | Should -Be $true 
        }
    }

    Context "The initial Write-ScreenshotWin tests" {

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
