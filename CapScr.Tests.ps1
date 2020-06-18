Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
    }

    Context 'Write-Screenshot path and filename parameter handling' {
        
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

        It 'Should create datetime-named file in current dir if path not supplied' {
            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }

        It 'Should create date-named file in the supplied folder' {
            Set-Variable folder -Option Constant -Value (Join-Path $TestDrive '/AnyFolder/SomeOtherFolder')
            Set-Variable fullPath -Option Constant -Value (Join-Path $folder $screenShotFilename)
            $fullPath | Should -Not -Exist
            Write-Screenshot $folder
            $fullPath | Should -Exist
        }

        It 'Should create correctly named file if Filename parameter is provided' -Skip {}
    }
}
