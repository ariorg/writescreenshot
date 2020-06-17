Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
    }
    Context 'Write-ScreenshotWin tests' {
        
        BeforeAll {
            Push-Location
        }

        AfterAll { 
            Pop-Location
        }
        
        It 'should create current-datetime-named-screenshotfile if no filename supplied' {
            [String]$fileDateFormat = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
            # [String]$screenShotFilename = Join-Path $PSScriptRoot "$fileDateFormat.jpg"
            [String]$screenShotFilename = "$fileDateFormat.jpg"
            Write-Host $screenShotFilename
            Write-Host $TestDrive
            Push-Location
            Set-Location $TestDrive
            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
            Pop-Location
        }
    }
}
