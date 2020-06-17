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
            Set-Variable dateStr -Option Constant -Value "07/06/2015 05:00:10" 

            mock -CommandName 'Get-Date' –MockWith {
               # [DateTime]$dateStr
               "yyyy-MM-ddTHH.mm.ss" 
            }

            [String]$fileDateFormat = Get-Date $dateStr -Format "yyyy-MM-ddTHH.mm.ss"
            [String]$screenShotFilename = "$fileDateFormat.jpg"

            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }
    }
}
