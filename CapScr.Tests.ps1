Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
    }

    Context 'Write-Screenshot datetime-named file tests' {
        
        BeforeAll {
            Push-Location
            Set-Location $TestDrive

            Set-Variable someDate -Option Constant -Value ([DateTime]"07/06/2015 05:00:10")
            Set-Variable dateFilenameFormat -Option Constant -Value "yyyy-MM-ddTHH.mm.ss" 
            Set-Variable screenShotFilename -Option Constant -Value "$($someDate.toString($dateFilenameFormat)).jpg"

            mock -CommandName 'Get-Date' –MockWith {
                param($Format)

                $Format | Should -Be $dateFilenameFormat
                return $someDate.toString($Format)
            }

        }

        AfterAll {
            Pop-Location
        }

        It 'should create datetime-named-screenshotfile in current dir if path not supplied' {
            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }

        It 'should create date-named screenshot file in the supplied folder' {
            Set-Variable folder -Option Constant -Value (Join-Path $TestDrive '/TestLocation/File')
            Write-Host $folder
            Set-Variable fullPath -Option Constant -Value (Join-Path $folder $screenShotFilename)
            Write-Host $fullPath
            $fullPath | Should -Not -Exist
            Write-Screenshot
            $fullPath | Should -Exist
        }
    }
}
