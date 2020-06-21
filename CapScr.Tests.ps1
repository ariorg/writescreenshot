Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
    }

    Context 'Write-Screenshot path and filename parameter handling' {
        
        BeforeAll {
            Push-Location
            Set-Location $TestDrive

            Set-Variable someDate           -Option Constant -Value ([DateTime]"07/06/2015 05:00:10")
            Set-Variable dateFilenameFormat -Option Constant -Value "yyyy-MM-ddTHH.mm.ss" 
            Set-Variable screenShotFilename -Option Constant -Value "$($someDate.toString($dateFilenameFormat)).jpg"
            Set-Variable someFolder         -Option Constant -Value (Join-Path $TestDrive '/AnyFolder/SomeOtherFolder')

            mock -CommandName 'Get-Date' –MockWith {
                param($Format)

                $Format | Should -Be $dateFilenameFormat
                return $someDate.toString($Format)
            }

        }

        AfterAll {
            Pop-Location
        }

        It 'Should create datetime-named file in current dir if FolderPath not supplied' {
            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }

        It 'Should create date-named file in the supplied FolderPath' {
            Set-Variable fullPath -Option Constant -Value (Join-Path $someFolder $screenShotFilename)
            $fullPath | Should -Not -Exist
            Write-Screenshot $someFolder
            $fullPath | Should -Exist
        }

        It 'Should create filename.jpg file if Filename parameter is provided' {
            Set-Variable someFilename -Option Constant -Value "SomeFilename"
            
            $someFilename | Should -Not -Exist
            Write-Screenshot -Filename $someFilename
            "$someFilename.jpg" | Should -Exist
        }
    }
}
