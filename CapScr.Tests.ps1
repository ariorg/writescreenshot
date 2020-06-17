Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
    }

    Context 'Write-ScreenshotWin tests' {
        
        BeforeAll {
            Push-Location
            Set-Location $TestDrive
        }

        AfterAll { 
            Pop-Location
        }
        
        It 'should create current-datetime-named-screenshotfile if no filename supplied' {
            Set-Variable someDate -Option Constant -Value ([DateTime]"07/06/2015 05:00:10")
            Set-Variable dateFormatFileName -Option Constant -Value "yyyy-MM-ddTHH.mm.ss" 
            Set-Variable screenShotFilename -Option Constant -Value "$($someDate.toString($dateFormatFileName)).jpg"
            
            mock -CommandName 'Get-Date' –MockWith {
                param($Format)
                $Format | Should -Be $dateFormatFileName
                $someDate.toString($Format)
            }

            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }
    }
}
