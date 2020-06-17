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
            $someDate = [DateTime]"07/06/2015 05:00:10" 
            $dateFormatFileName = "yyyy-MM-ddTHH.mm.ss" 

            mock -CommandName 'Get-Date' –MockWith {
                param($Format)
                $Format | Should -Be $dateFormatFileName
                $someDate.toString($Format)
            }

            [String]$fileDateFormat = $someDate.toString($dateFormatFileName)
            [String]$screenShotFilename = "$fileDateFormat.jpg"

            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }
    }
}
